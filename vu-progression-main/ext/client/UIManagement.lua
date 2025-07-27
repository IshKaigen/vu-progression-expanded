-- NO CHANGES NEEDED IN THIS FILE. THIS VERSION IS CORRECT.

local UIManagement = {}

function UIManagement:Init(ui_object)
    print("--- UI LOG: UIManagement:Init() called. ---")
    
    self.ui = ui_object
    
    if self.ui == nil then
        print("!!! CRITICAL UI ERROR: The UI object passed from __init__.lua was nil! !!!")
        return
    else
        print("--- UI LOG: Received valid UI object. Setting URL. ---")
    end
    
    self.ui:SetUrl('vu://vu-progression-main/ui.vuic')
    print("--- UI LOG: URL set to 'vu://vu-progression-main/ui.vuic'. ---")
    
    self.ui:SetResolution(1920, 1080)
    self.ui.visible = true
    print("--- UI LOG: UI resolution set. Subscribing to events. ---")

    NetEvents:Subscribe('ShowRankUpPopup', function(data)
        print("--- UI LOG: Received 'ShowRankUpPopup' from server for rank: " .. data.rankName)
        if self.ui ~= nil then
            local itemName = string.match(data.unlockedItem, "/([^/]+)$") or data.unlockedItem
            self.ui:ExecuteJS(string.format(
                "showRankUp('%s', '%s', '%s', '%s')",
                data.rankName,
                data.rankImage,
                itemName,
                ""
            ))
            print("--- UI LOG: Executed JS 'showRankUp'. ---")
        end
    end)

    NetEvents:Subscribe('ShowAttachmentUnlockPopup', function(data)
        print("--- UI LOG: Received 'ShowAttachmentUnlockPopup' from server. ---")
        if self.ui ~= nil then
            local attachmentName = string.match(data.attachmentPath, "/U_([^/]+)$") or data.attachmentPath
            attachmentName = attachmentName:gsub("_", " ")
            local weaponName = string.match(data.weaponName, "/([^/]+)$") or data.weaponName
            self.ui:ExecuteJS(string.format(
                "showAttachmentUnlock('%s', '%s', '%s')",
                attachmentName,
                weaponName,
                ""
            ))
        end
    end)

    print("--- UI LOG: UIManagement Initialized. Popups are ready. ---")
end

return UIManagement