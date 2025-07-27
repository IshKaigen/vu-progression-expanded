require("__shared/KitVariables")

-- Function to remove all the customization options on the selected soldier
function LockSoldierCustomizationAsset(veniceSoldierAsset, categoryId)
    local weaponTable = CustomizationTable(veniceSoldierAsset.weaponTable)
    for i,unlockPart in pairs(weaponTable.unlockParts) do
        local unlockPart = CustomizationUnlockParts(unlockPart)
        unlockPart:MakeWritable()

        local partCatId = unlockPart.uiCategorySid

        if partCatId == categoryId then
            for i = #unlockPart.selectableUnlocks,0,-1 do
                -- if i ~= 1 then
                if unlockPart.selectableUnlocks[i] ~= nil then
                    unlockPart.selectableUnlocks:erase(i)
                end 
                -- end
            end
        end
        
    end
end

-- Function to remove all the specialization options on the selected soldier
function lockSoldierSpecializationAsset(veniceSoldierAsset)
    local characterCustomizationAsset = CharacterCustomizationAsset(veniceSoldierAsset)

    local specialTable = CustomizationTable(characterCustomizationAsset.specializationTable)

    if specialTable ~= nil then
        for _, unlockPart in pairs(specialTable.unlockParts) do
            local unlockPart = CustomizationUnlockParts(unlockPart)
            unlockPart:MakeWritable()

            for i = #unlockPart.selectableUnlocks,1,-1 do
                unlockPart.selectableUnlocks:erase(i)
            end
        end
    end
end

-- Function to remove all the customization options on the selected weapon
function LockWeaponCustomizationAsset(weaponCustomizationAsset)
    local attachTable = CustomizationTable(weaponCustomizationAsset.customization)
    -- print("{name = " .. weaponCustomizationAsset.name .. "}")

    for i, unlockPart in pairs(attachTable.unlockParts) do

        local unlockPart = CustomizationUnlockParts(unlockPart)
        unlockPart:MakeWritable()

        -- print("INDEX: " .. i)

        for i = #unlockPart.selectableUnlocks,1,-1 do
            -- print("UNLOCK: ")
            -- print(unlockPart.selectableUnlocks[i])
            unlockPart.selectableUnlocks:erase(i)
        end
    end
end


-- Events:Subscribe('Partition:Loaded', function(partition)
--     for _, instance in pairs(partition.instances) do
--         if instance:Is("VeniceSoldierWeaponCustomizationAsset") then
--             local weaponCustomizationAsset = VeniceSoldierWeaponCustomizationAsset(instance)

--             print(weaponCustomizationAsset.name)
--         end
--     end
-- end)

function InitAssetsLock()
    -- Loop through all the kits and lock all assets
    if kits ~= nil then
        if #kits > 0 then
            print(">>>>>>>>LOCKING KIT ASSETS<<<<<<<<")
            for _, kit in pairs(kits) do
                local veniceSoldierAsset = ResourceManager:SearchForDataContainer(kit)

                if veniceSoldierAsset ~= nil then
                    veniceSoldierAsset = VeniceSoldierCustomizationAsset(veniceSoldierAsset)

                    -- Lock primary weapons
                    LockSoldierCustomizationAsset(veniceSoldierAsset, kitPrimaryWeaponID)

                    -- Lock secondary weapons
                    LockSoldierCustomizationAsset(veniceSoldierAsset, kitSecondaryWeaponID)

                    -- Lock specializations
                    lockSoldierSpecializationAsset(veniceSoldierAsset)

                    -- Lock Soldier Gadget 1
                    LockSoldierCustomizationAsset(veniceSoldierAsset, kitSoldierGadget1ID)

                    -- Lock Soldier Gadget 2
                    LockSoldierCustomizationAsset(veniceSoldierAsset, kitSoldierGadget2ID)

                    -- Lock Assualt and Support special gadget
                    LockSoldierCustomizationAsset(veniceSoldierAsset, kitWeaponCatGadgetID)

                    -- Lock Gadget 1
                    LockSoldierCustomizationAsset(veniceSoldierAsset, kitGadget1ID)

                end
            end
        end
    end

    -- Loop through all the weapon customization assets
    if weaponCustoms ~= nil then
        if #weaponCustoms > 0 then
            print(">>>>>>>>LOCKING WEAPON CUSTOMIZATION ASSETS<<<<<<<<")
            for _, weaponCustom in pairs(weaponCustoms) do
                local weaponCustomizationAsset = ResourceManager:SearchForDataContainer(weaponCustom)

                if weaponCustomizationAsset ~= nil then
                    weaponCustomizationAsset = VeniceSoldierWeaponCustomizationAsset(weaponCustomizationAsset)

                    LockWeaponCustomizationAsset(weaponCustomizationAsset)
                end
            end
        end
    end
end