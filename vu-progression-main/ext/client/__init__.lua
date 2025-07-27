-- ==============================================================================
-- FINAL DEFINITIVE FIX v4 (client/__init__.lua)
-- This version solves the engine timing and race condition issues.
-- ==============================================================================

local UIManagement = require('UIManagement')

require('LockEquipment')
require('UnlockEquipment')

require('__shared/config')
require("__shared/KitVariables")
local generalProgressionUnlockList = require("__shared/Progression/GeneralProgressionConfig")
local assaultProgressionUnlockList = require("__shared/Progression/AssaultProgressionConfig")
local engineerProgressUnlockList = require("__shared/Progression/EngineerProgressionConfig")
local supportProgressUnlockList = require("__shared/Progression/SupportProgressionConfig")
local reconProgressUnlockList = require("__shared/Progression/ReconProgressionConfig")
local weaponProgressUnlocks = require("__shared/Progression/WeaponProgressionConfig")

local uiInitListener = nil

function UnlockClientItem(levelCat, currentXp)
    if levelCat == 'General' then
        if #generalProgressionUnlockList > 0 then
            for _, unlock in pairs(generalProgressionUnlockList) do if unlock.xpRequired <= currentXp then ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.kit) end end
        end
    elseif levelCat == 'Assault' then
        if #assaultProgressionUnlockList > 0 then
            for _, unlock in pairs(assaultProgressionUnlockList) do if unlock.xpRequired <= currentXp then print("THE FOUND UNLOCK IS: "); print(unlock); ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.uskit); ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.rukit) end end
        end
    elseif levelCat == 'Engineer' then
        if #engineerProgressUnlockList > 0 then
            for _, unlock in pairs(engineerProgressUnlockList) do if unlock.xpRequired <= currentXp then ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.uskit); ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.rukit) end end
        end
    elseif levelCat == 'Support' then
        if #supportProgressUnlockList > 0 then
            for _, unlock in pairs(supportProgressUnlockList) do if unlock.xpRequired <= currentXp then ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.uskit); ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.rukit) end end
        end
    elseif levelCat == 'Recon' then
        if #reconProgressUnlockList > 0 then
            for _, unlock in pairs(reconProgressUnlockList) do if unlock.xpRequired <= currentXp then ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.uskit); ApplyUnlock(unlock.equipmentPath, unlock.slotId, unlock.rukit) end end
        end
    end
end

function UnlockClientAttachment(weaponName, kills)
    if #weaponProgressUnlocks > 0 then
        for _, weaponUnlocks in pairs(weaponProgressUnlocks) do
            if weaponUnlocks.weaponName == weaponName then
                if #weaponUnlocks.unlocks > 0 then
                    for _, unlocks in pairs(weaponUnlocks.unlocks) do if kills >= unlocks.killsRequired then UnlockAttachment(weaponUnlocks.customizationPath, unlocks.attachmentPath, unlocks.attachmentSlotIndex) end end
                end
                break
            end
        end
    end 
end

Events:Subscribe('Level:Finalized', function(levelName, gameMode)
    -- Step 1: Lock everything.
    InitAssetsLock()

    print("--- UI LOG: Level is finalized. Starting listener to wait for engine readiness. ---")

    -- Step 2: Start a listener that waits for the engine's UI system to be ready.
    uiInitListener = Events:Subscribe('Client:Update', function(dt)
        -- This code runs every frame.
        if Shared and Shared.WebUI then
            -- Step 3: The engine is ready. Initialize the UI.
            print("--- UI LOG: 'Shared.WebUI' is now available. Initializing UI. ---")
            
            local ui = Shared.WebUI:Create()
            if ui == nil then
                 print("!!! CRITICAL UI ERROR: Shared.WebUI:Create() failed.!!!")
            else
                UIManagement:Init(ui)
                -- Step 4: The UI is confirmed to be ready. NOW we ask the server for stats.
                print("--- UI LOG: UI is ready. Requesting player stats from server. ---")
                NetEvents:Send('AddNewPlayerForStats', 'Adding new player to Stats')
            end
            
            -- Step 5: Stop listening so this code only ever runs once.
            if uiInitListener ~= nil then
                uiInitListener:Disconnect()
                uiInitListener = nil
            end
        end
    end)
end)

-- The rest of the file is your original, working code. It is unchanged.
NetEvents:Subscribe('OnInitialUnlock', function(levelCat, currentXp)
    print("THE SELECTED LEVEL CAT IS:")
    print(levelCat)
    UnlockClientItem(levelCat, currentXp)
end)

NetEvents:Subscribe('OnInitialAttachmentUnlock', function(weaponProgressList)
    print("UNLOCKING INITIAL ATTACHMENTS")
    if #weaponProgressList > 0 then
        for _, weapon in pairs(weaponProgressList) do UnlockClientAttachment(weapon.weaponName, weapon.kills) end
    end
end)

NetEvents:Subscribe('OnKilledPlayer', function(weaponName, kills)
    print("RECIEVED " .. tostring(kills) .. " KILLS WITH THE WEAPON " .. weaponName)
    UnlockClientAttachment(weaponName, kills)
end)

NetEvents:Subscribe('OnLevelUp', function(levelCat, currentXp)
    UnlockClientItem(levelCat, currentXp)
end)

local command = Console:Register('addExperience', 'Adds Experience', function()
	NetEvents:Send('AddExperience', 40000)
end)

local command = Console:Register('addKill', 'Adds Kill for M16', function()
	NetEvents:Send('AddKill', 'Weapons/M16A4/M16A4')
end)