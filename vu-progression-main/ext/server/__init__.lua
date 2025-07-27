require("__shared/config")
require("__shared/KitVariables")
require("SQL/DBCreation")

local generalProgressionUnlockList = require("__shared/Progression/GeneralProgressionConfig")
local assaultProgressionUnlockList = require("__shared/Progression/AssaultProgressionConfig")
local engineerProgressUnlockList = require("__shared/Progression/EngineerProgressionConfig")
local supportProgressUnlockList = require("__shared/Progression/SupportProgressionConfig")
local reconProgressUnlockList = require("__shared/Progression/ReconProgressionConfig")
local rankingStorageManager = require('SQL/RankingStorageManager')
playerRankClass = require('__shared/PlayerRank')

-- === ADDON START: Safe loading of new configs ===
local RankConfig = require('__shared/Progression/RankConfig')

-- This pcall (protected call) is critical. It will try to load your weapon progression file.
-- If the file is missing or has a syntax error, it will NOT crash the server script.
-- Instead, it will print a warning to the console and attachment popups will be disabled.
-- THIS IS HOW WE ENSURE YOUR MOD'S CORE LOGIC ALWAYS RUNS.
local success, weaponProgressUnlocks = pcall(require, "__shared/Progression/WeaponProgressionConfig")
if not success then
    print("!!! WARNING: Could not load '__shared/Progression/WeaponProgressionConfig.lua'. It may be missing or contain errors. Attachment popups will be disabled. !!!")
    weaponProgressUnlocks = {} -- Create an empty table to prevent errors later.
end
-- === ADDON END ===

currentRankupPlayers = {}

function AddPlayerToRankUpList(player)
    local playerRankObject = playerRankClass(player)
    playerRankObject = rankingStorageManager:FetchPlayerProgress(playerRankObject)
    print("NEW PLAYER GUID: ")
    print(playerRankObject['r_PlayerGuid'])
    
    local foundPlayer = false
    if #currentRankupPlayers > 0 then
        for _, cPlayer in pairs(currentRankupPlayers) do
            if cPlayer['r_PlayerGuid'] == player.guid then
                print(player.name .. ' IS ALREADY ON THE LIST')
                foundPlayer = true
                break
            end
        end
    end

    if not foundPlayer then
        print("ADDING " .. player.name .. " TO THE RANKUP LIST")
        table.insert(currentRankupPlayers, playerRankObject)
    end

    initPlayerLevels(player, playerRankObject)
end

-- This function is UNCHANGED from your original. It correctly sends OnInitialUnlock.
function initPlayerLevels(player, playerRankObject)
    NetEvents:SendTo('OnInitialUnlock', player, "General", playerRankObject['r_PlayerCurrentXP'])
    NetEvents:SendTo('OnInitialUnlock', player, "Assault", playerRankObject['r_AssaultCurrentXP'])
    NetEvents:SendTo('OnInitialUnlock', player, "Engineer", playerRankObject['r_EngineerCurrentXP'])
    NetEvents:SendTo('OnInitialUnlock', player, "Support", playerRankObject['r_SupportCurrentXP'])
    NetEvents:SendTo('OnInitialUnlock', player, "Recon", playerRankObject['r_ReconCurrentXP'])

    if #playerRankObject['r_WeaponProgressList'] > 0 then
        NetEvents:SendTo('OnInitialAttachmentUnlock', player, playerRankObject['r_WeaponProgressList'])
    end
end

-- This function is UNCHANGED from your original.
function PlayerXPUpdated(player, score)
    local selectedKit = player.customization
    if not selectedKit then return end
    local kitData = DataContainer(selectedKit)
    local veniceSoldierAsset = VeniceSoldierCustomizationAsset(kitData)
    veniceSoldierAsset:MakeWritable()
    local kitName = veniceSoldierAsset.labelSid
    local xp = score * xpMultiplier

    for playerIndex, cPlayer in pairs(currentRankupPlayers) do
        if cPlayer['r_PlayerGuid'] == player.guid then
            print("Found a player to increase XP!!!!")
            if kitName == 'ID_M_ASSAULT' then
                IncreasePlayerXP(playerIndex, 'r_AssaultLevel', 'r_AssaultCurrentXP', xp, assaultProgressionUnlockList, "Assault")
            elseif kitName == 'ID_M_ENGINEER' then
                IncreasePlayerXP(playerIndex, 'r_EngineerLevel', 'r_EngineerCurrentXP', xp, engineerProgressUnlockList, "Engineer")
            elseif kitName == 'ID_M_SUPPORT' then
                IncreasePlayerXP(playerIndex, 'r_SupportLevel', 'r_SupportCurrentXP', xp, supportProgressUnlockList, "Support")
            elseif kitName == 'ID_M_RECON' then
                IncreasePlayerXP(playerIndex, 'r_ReconLevel', 'r_ReconCurrentXP', xp, reconProgressUnlockList, "Recon")
            end
            -- General XP is separate and always granted
            IncreasePlayerXP(playerIndex, 'r_PlayerLevel', 'r_PlayerCurrentXP', xp, generalProgressionUnlockList, "General")
            break
        end
    end
end

-- This function is UNCHANGED from your original, but now has the ADDON for popups.
function IncreaseWeaponKills(playerIndex, weaponName) 
    if not currentRankupPlayers[playerIndex] then return end

    if #currentRankupPlayers[playerIndex]['r_WeaponProgressList'] > 0 then
        for _, weapon in pairs(currentRankupPlayers[playerIndex]['r_WeaponProgressList']) do
            if weapon['weaponName'] == weaponName then
                local oldKills = weapon['kills'] -- Capture kills before incrementing
                weapon['kills'] = weapon['kills'] + 1
                print("THE WEAPON " .. weapon['weaponName'] .. " CURRENT KILLS IS " .. tostring(weapon['kills']))

                local player = PlayerManager:GetPlayerByGuid(currentRankupPlayers[playerIndex]['r_PlayerGuid'])
                if player ~= nil then
                    NetEvents:SendTo('OnKilledPlayer', player, weapon['weaponName'], weapon['kills'])
                    
                    -- === ADDON START: Attachment Popup Logic ===
                    if weaponProgressUnlocks and #weaponProgressUnlocks > 0 then
                        local weaponConfig
                        for _, wc in pairs(weaponProgressUnlocks) do
                            if wc.weaponName == weaponName then weaponConfig = wc; break end
                        end
                        if weaponConfig and weaponConfig.unlocks then
                            for _, unlock in pairs(weaponConfig.unlocks) do
                                if oldKills < unlock.killsRequired and weapon['kills'] >= unlock.killsRequired then
                                    NetEvents:SendTo('ShowAttachmentUnlockPopup', player, {
                                        attachmentPath = unlock.attachmentPath,
                                        weaponName = weaponName
                                    })
                                end
                            end
                        end
                    end
                    -- === ADDON END ===
                end
                break
            end
        end
    end
end

-- This function is UNCHANGED from your original.
function IncreasePlayerXP(playerIndex, levelKey, xpKey, xpValue, progressUnlockList, levelType)
    currentRankupPlayers[playerIndex][xpKey] = currentRankupPlayers[playerIndex][xpKey] + xpValue

    if #progressUnlockList > 0 then
        local oldLevel = currentRankupPlayers[playerIndex][levelKey]
        for _, aProgress in pairs(progressUnlockList) do
            if currentRankupPlayers[playerIndex][levelKey] < aProgress.lvl and currentRankupPlayers[playerIndex][xpKey] >= aProgress.xpRequired then
                currentRankupPlayers[playerIndex][levelKey] = aProgress.lvl
                print("CHANGED " .. levelType .. " PROGRESSION TO LEVEL " .. tostring(currentRankupPlayers[playerIndex][levelKey]))
                
                -- We only call PlayerLevelUp if the level number actually changed.
                PlayerLevelUp(playerIndex, levelType, currentRankupPlayers[playerIndex][xpKey], aProgress)
            end
        end
    end
end

-- This function is UNCHANGED from your original, but now has the ADDON for popups.
function PlayerLevelUp(playerIndex, levelType, currentXp, unlockData)
    local player = PlayerManager:GetPlayerByGuid(currentRankupPlayers[playerIndex]['r_PlayerGuid'])
    if player ~= nil then
        -- This is the original, critical event that unlocks the item for the client.
        NetEvents:SendTo('OnLevelUp', player, levelType, currentXp)

        -- === ADDON START: Rank Up Popup Logic ===
        -- This is called right after, specifically to trigger the UI popup.
        if levelType ~= "General" and unlockData then
            local rankTable = RankConfig[levelType]
            local currentLevel = currentRankupPlayers[playerIndex][levelType .. 'Level']
            local newRankInfo
            if rankTable then
                 for _, rank in pairs(rankTable) do
                    if rank.lvl == currentLevel then newRankInfo = rank; break end
                end
            end
            if newRankInfo then
                 print("Player ranked up! Class: "..levelType..", New rank: " .. newRankInfo.name)
                 NetEvents:SendTo('ShowRankUpPopup', player, {
                     rankName = newRankInfo.name,
                     rankImage = newRankInfo.image,
                     unlockedItem = unlockData.equipmentPath
                 })
            end
        end
        -- === ADDON END ===
    end
end

-- All remaining functions and event subscribers are UNCHANGED from your original file.
function StoreAllPlayerStats()
    if #currentRankupPlayers > 0 then
        for playerIndex, cPlayer in pairs(currentRankupPlayers) do
            if cPlayer then rankingStorageManager:StorePlayerProgress(cPlayer) end
        end
    end
end
Events:Subscribe('Player:Score', function(player, scoringTypeData, score)
    if player.guid ~= nil then PlayerXPUpdated(player, score) end
end)
Events:Subscribe('Player:Killed', function(player, inflictor, position, weapon, isRoadKill, isHeadShot, wasVictimInReviveState, info)
    if inflictor and inflictor.name == 'MJShepherd' then print(player.name .. " was killed by " .. inflictor.name .. " with a " .. weapon) end
    if player and player.guid then
        for i, p in pairs(currentRankupPlayers) do
            if p['r_PlayerGuid'] == player.guid then p['r_Deaths'] = p['r_Deaths'] + 1; break end
        end
    end
    if inflictor and inflictor.guid then
        for i, p in pairs(currentRankupPlayers) do
            if p['r_PlayerGuid'] == inflictor.guid then p['r_Kills'] = p['r_Kills'] + 1; IncreaseWeaponKills(i, weapon); break end
        end
    end
end)
Events:Subscribe('Player:Joining', function(name, playerGuid, ipAddress, accountGuid) end)
Events:Subscribe('Player:Created', function(player) end)
NetEvents:Subscribe('AddNewPlayerForStats', function(player, data) AddPlayerToRankUpList(player) end)
Events:Subscribe('Player:Left', function(player)
    if #currentRankupPlayers > 0 then
        for i, p in pairs(currentRankupPlayers) do
            if p['r_PlayerGuid'] == player.guid then rankingStorageManager:StorePlayerProgress(p); table.remove(currentRankupPlayers, i); break end
        end
    end
end)
NetEvents:Subscribe('AddExperience', function(player, data) PlayerXPUpdated(player, data) end)
NetEvents:Subscribe('AddKill', function(player, data)
    if player and player.guid then
        for i, p in pairs(currentRankupPlayers) do
            if p['r_PlayerGuid'] == player.guid then p['r_Kills'] = p['r_Kills'] + 10; IncreaseWeaponKills(i, 'Weapons/M16A4/M16A4'); break end
        end
    end
end)
Events:Subscribe('Extension:Loaded', function() print('Initializing VU Progression DB'); CreateProgressionTable() end)
Events:Subscribe('Server:RoundOver', function(roundTime, winningTeam) print("THE ROUND IS OVER!!! TIME TO SAVE THE CONNECTED PLAYERS' STATS!!!!"); StoreAllPlayerStats() end)