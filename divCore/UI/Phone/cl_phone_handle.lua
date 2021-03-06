RegisterNetEvent('phone.ReceiveEmail')
RegisterNetEvent('phone.ReceiveMessage')

TriggerEvent('scalePhone.BuildApp', 'app_messageView', "messageView", "Rules", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_messages', contact = "Contact", message = 'unk', fromme = false, hasPic = "CHAR_BLANK_ENTRY", canOpenMenu = false, selectEvent = ""}) --creating custom app for messages.
TriggerEvent('scalePhone.BuildApp', 'app_emailView', "emailView", "Rules", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_emails'}) --creating custom app for emails.

AddEventHandler('phone.ReceiveEmail', function(email)
    local mails = {title = email.title, to = email.to, from = email.from, message = email.message, event = 'phone.OpenEmail', canOpenMenu = false, selectEvent = ""}
    mails.eventParams = mails
    notifyex('CHAR_LESTER', 'New Email!', "From: "..email.from, 2, email.message, 123)
    TriggerEvent('scalePhone.BuildAppButton', 'app_emails', mails, true, -1)
    TriggerEvent('scalePhone.AddAppNotification', 'app_emails')
end)

AddEventHandler('phone.ReceiveMessage', function(sms, isMine)
    local mess = {svID = sms.svID, contact = sms.contact, h = GetClockHours(), m = GetClockMinutes(), message = sms.message, event = 'phone.OpenMessage', isentthat = isMine, hasPic = sms.hasPic, canOpenMenu = true, selectEvent = "phone.OpenMessageOptions"}
    mess.eventParams = mess
    mess.eventParams.raw = sms --redundant garbage. But I don't have time to make sure eventParams doesn't break anything, and I hate this code anyway, k bye.
    if sms.hasPic ~= nil then
        mess.hasPic = sms.hasPic
    end
    mess.eventParams.identifier = "/"..sms.contact.."/"..sms.message.."/"..tostring(isMine).."/" -- we set up a unique string in the message data, to make sure we can find it at a later stage.
    TriggerEvent('scalePhone.BuildAppButton', 'app_messages', mess, true, -1)
    if isMine == false then
        TriggerEvent('scalePhone.AddAppNotification', 'app_messages')
        notifyex(mess.hasPic, 'New Message!', "From: "..mess.contact, 1, mess.message, 123)
    end
end)

AddEventHandler('phone.OpenMessage', function(data)
    TriggerEvent('scalePhone.BuildMessageView', data, 'app_messageView')
    TriggerEvent('scalePhone.OpenApp', 'app_messageView', false) -- app '1000' is a prebuilt app for message viewing. It backs out to the last application opened. Doesn't have a menu.
end)

AddEventHandler('phone.OpenMessageOptions', function(data)
    TriggerEvent('scalePhone.BuildApp', 'app_message_options', "settings", data.contact, 5, 0, "", "scalePhone.GoBackApp", {backApp = 'app_messages'}) --you can build the app how many times you want. If it's the same appID, it will just overwrite it (and clear all buttons!)
    if tonumber(data.svID) ~= nil and tonumber(data.svID) > 0 then --if it's not a bot, add these buttons too.
        if data.raw.isGroupInvite == true then
            TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Accept Invite", icon = 0, event = "phone.ReplyToGroupInvite", eventParams = {groupID = data.raw.groupID, response = true, deleteParams = {appID = 'app_messages', dataSample = data.identifier}}}, false, -1) --accept group invite.
            TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Reject Invite", icon = 0, event = "phone.ReplyToGroupInvite", eventParams = {groupID = data.raw.groupID, response = false, deleteParams = {appID = 'app_messages', dataSample = data.identifier}}}, false, -1) --accept group invite.
        else
            TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Reply", icon = 25, event = "phone.SendSMS", eventParams = {name = data.contact, isBot = false, svID = data.svID}}, false, -1) --Send a message back to the other player.
            TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Call "..data.contact, icon = 25, event = "phone.SendCall", eventParams = {name = data.contact, pic = data.hasPic, isBot = false, svID = data.svID}}, false, -1) --call the other player directly
        end
    end
    TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Delete Message", icon = 19, event = 'phone.DeleteMessage', eventParams = {appID = 'app_messages', dataSample = data.identifier}}, false, -1) --deleting the message

    TriggerEvent('scalePhone.OpenApp', 'app_message_options', false) --at the end, we open the app.
end)

AddEventHandler('phone.DeleteMessage', function(data)
    TriggerEvent("scalePhone.RemoveButtonUsingData", data) --deleting the message from framework
    TriggerEvent('scalePhone.GoBackApp', {backApp = 'app_messages'}) --going back to messages list.
end)

AddEventHandler('phone.OpenEmail', function(data)
    TriggerEvent('scalePhone.BuildEmailView', data, 'app_emailView')
    TriggerEvent('scalePhone.OpenApp', 'app_emailView', false) -- app '1001' is a prebuilt app for email viewing. It backs out to the last application opened. Doesn't have a menu.
end)

--------------------------------------------------------------------------

RegisterNetEvent('phone.UpdateContacts')
RegisterNetEvent('phone.ReceiveCall')

AddEventHandler('phone.UpdateContacts', function(contacts) --we receive contacts from the server-side.
    TriggerEvent('scalePhone.ResetAppButtons', 'app_contacts') --first. We clear all contacts that we currently have. app_group_members
    TriggerEvent('scalePhone.ResetAppButtons', 'app_group_members')
    for i,k in pairs(contacts) do
        --local idc = {name = k.name, pic = k.pic, isBot = k.isBot, event = "eventName", eventParams = {name = k.name, isBot = k.isBot}}
        local idc = {name = k.name, pic = k.pic, isBot = k.isBot, event = "phone.OpenContactView", eventParams = {name = k.name, isBot = k.isBot, pic = k.pic, svID = k.svID, group = k.group, lead = k.lead}}
        if k.svID ~= nil then --if we got the server ID, or playerSrc, from the server, we include it in the eventParams. WE SHOULD GET IT, BY THE WAY.
            idc.eventParams.svID = k.svID
        end
        TriggerEvent('scalePhone.BuildAppButton', 'app_contacts', idc, k.isBot, -1) --adding the contact. If it's a bot, we add it at the top.
        if k.group == PlayerInfo.group and k.group ~= 0 and k.isBot == false then
            local idc2 = {name = k.name, pic = k.pic, isBot = k.isBot, event = "phone.OpenGroupMemberView", eventParams = {name = k.name, isBot = k.isBot, pic = k.pic, svID = k.svID, group = k.group, lead = k.lead}}
            if k.svID ~= nil then --if we got the server ID, or playerSrc, from the server, we include it in the eventParams. WE SHOULD GET IT, BY THE WAY.
                idc2.eventParams.svID = k.svID
            end
            if k.lead == true then
                idc2.name = "[leader]"..idc2.name
            end
            TriggerEvent('scalePhone.BuildAppButton', 'app_group_members', idc2, false, -1)
        end
    end

end)

TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "phone.CloseCall", {backApp = 'app_contacts', contact = "unk", pic = "", status = "DIALING", canAnswer = false, selectEvent = ""})

AddEventHandler('phone.OpenContactView', function(data) --this is the contact view. Where we have multiple options, like calling or messaging.
    TriggerEvent('scalePhone.BuildApp', 'app_contact_view', "settings", data.name, 5, 0, "", "scalePhone.GoBackApp", {backApp = 'app_contacts'}) --you can build the app how many times you want. If it's the same appID, it will just overwrite it (and clear all buttons!)
    TriggerEvent('scalePhone.BuildAppButton', 'app_contact_view', {text = "Call", icon = 25, event = "phone.SendCall", eventParams = data}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_contact_view', {text = "Message", icon = 19, event = "phone.SendSMS", eventParams = data}, false, -1)
    if tonumber(data.svID) > 0 then --if it's not a bot, add these buttons too.
        if data.group == 0 then
            --phone.InviteToGroup
            TriggerEvent('scalePhone.BuildAppButton', 'app_contact_view', {text = "Invite to group", icon = 25, event = "phone.InviteToGroup", eventParams = data}, false, -1)
        end
    end

    TriggerEvent('scalePhone.OpenApp', 'app_contact_view', false) --at the end, we open the app.
end)

AddEventHandler('phone.SendCall', function(data)
    TriggerEvent('scalePhone.BuildCallscreenView', {backApp = 'app_contacts', contact = data.name, pic = data.pic, status = "CALLING", canAnswer = false, selectEvent = ""}, 'call_screen')
    TriggerEvent('scalePhone.OpenApp', 'call_screen', false)
    TriggerServerEvent('phone.sv.SendCall', data.name, data.pic, data.isBot, data.svID)
end)

AddEventHandler('phone.SendSMS', function(data)
    AddTextEntry('MS_PROMPT_SMS', "Send message to "..data.name..":")
    openMessagePrompt(data.name, data.isBot, data.svID)
end)

AddTextEntry('MS_PROMPT_SMS', "Send message:")
function openMessagePrompt(name, isBot, svID)
    Citizen.CreateThread(function()
        DisplayOnscreenKeyboard(1, "MS_PROMPT_SMS", "", "", "", "", "", 150)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            TriggerServerEvent('phone.sv.SendSMS', name, result, isBot, svID)
        end
        AddTextEntry('MS_PROMPT_SMS', "Send message: ")
    end)
end

AddEventHandler('phone.ReceiveCall', function(status, name, pic, isBot) --receiving a call, or a call update.
    if status == "dialing" then --client IS CALLING someone
        StopPedRingtone(PlayerPedId())
        PlayPedRingtone("Remote_Ring", PlayerPedId(), 1)
    elseif status == 'rejected' then --call gets rejected, or other person is not available / in Sleep Mode / in other call etc.
        StopPedRingtone(PlayerPedId())
        TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "phone.CloseCall", {backApp = 'app_contacts', contact = name, pic = pic, status = "REJECTED"})
        TriggerEvent('scalePhone.OpenApp', 'call_screen')
        Citizen.Wait(3000)
        if exports.scalePhone:getAppOpen(false) == 'call_screen' then
            PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1)
            ExecuteCommand('phoneback')
        end
    elseif status == 'calling' then --Client gets called by someone.
        StopPedRingtone(PlayerPedId())
        TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "phone.CloseCall", {backApp = 'app_contacts', contact = name, pic = pic, status = "IS CALLING", canAnswer = true, selectEvent = "phone.AnswerCall"})
        TriggerEvent('scalePhone.OpenApp', 'call_screen', true)
        PlayPedRingtone("PHONE_GENERIC_RING_01", PlayerPedId(), 0)
    elseif status == 'responded' then --Call gets answered by other person. You now should be in the Call channel.
        StopPedRingtone(PlayerPedId())
        if exports.scalePhone:getAppOpen(false) == 'call_screen' then
            TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "phone.CloseCall", {backApp = 'app_contacts', contact = name, pic = pic, status = "CONNECTED"})
            TriggerEvent('scalePhone.OpenApp', 'call_screen')
        end
    elseif status == 'hangup' then --Other persone hanged up the call.
        StopPedRingtone(PlayerPedId())
        if exports.scalePhone:getAppOpen(false) == 'call_screen' then
            TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "phone.CloseCall", {backApp = 'app_contacts', contact = name, pic = pic, status = "CALL ENDED"})
            TriggerEvent('scalePhone.OpenApp', 'call_screen')
            Citizen.Wait(3000)
            if exports.scalePhone:getAppOpen(false) == 'call_screen' then
                PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1)
                ExecuteCommand('phoneback')
            end
        end
    end
end)

AddEventHandler('phone.AnswerCall', function()
    TriggerServerEvent('phone.sv.SendCallUpdate', 'answer')
end)

AddEventHandler('phone.CloseCall', function(data)
    TriggerServerEvent('phone.sv.SendCallUpdate', 'hangup')
    TriggerEvent('scalePhone.GoBackApp', data)
end)

AddEventHandler('phone.InviteToGroup', function(_data)
    local pID = tonumber(_data.svID)
    AddTextEntry('MS_PROMPT_SMS', "Invite message: ")
    DisplayOnscreenKeyboard(1, "MS_PROMPT_SMS", "", "", "", "", "", 50)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        --TriggerServerEvent('phone.sv.SendSMS', name, result, isBot, svID)
        TriggerServerEvent('core.InviteToGroup', pID, result)
    end
    AddTextEntry('MS_PROMPT_SMS', "Send message: ")
end)

AddEventHandler('phone.LeaveGroup', function()
    TriggerServerEvent('core.LeaveGroup')
    TriggerEvent('scalePhone.OpenApp', 'app_more', false)
end)

AddEventHandler('phone.KickMemberFromGroup', function(_data)
    TriggerServerEvent('core.KickMemberFromGroup', _data.svID)
    TriggerEvent('scalePhone.OpenApp', 'app_more', false)
end)

AddEventHandler('phone.ReplyToGroupInvite', function(_data)
    TriggerServerEvent('core.ReplyToGroupInvite', _data.groupID, _data.response)
    TriggerEvent('phone.DeleteMessage', _data.deleteParams)
end)

AddEventHandler('phone.ChangeGroupSetting', function(data)
    if data.type == "name" then
        AddTextEntry('MS_PROMPT_SMS', "Set group name: ")
        DisplayOnscreenKeyboard(1, "MS_PROMPT_SMS", "", "", "", "", "", 10)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            --TriggerServerEvent('phone.sv.SendSMS', name, result, isBot, svID)
            TriggerServerEvent('core.ChangeGroupName', result)
        end
        AddTextEntry('MS_PROMPT_SMS', "Send message: ")
    elseif data.type == "color" then
        TriggerServerEvent('core.ChangeGroupColor', data.colID)
    end
end)
