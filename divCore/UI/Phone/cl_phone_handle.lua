RegisterNetEvent('phone.ReceiveEmail')
RegisterNetEvent('phone.ReceiveMessage')

TriggerEvent('scalePhone.BuildApp', 'app_messageView', "messageView", "Rules", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_messages', contact = "Contact", message = 'unk', fromme = false, hasPic = "CHAR_BLANK_ENTRY", canOpenMenu = false, selectEvent = ""}) --creating custom app for messages.
TriggerEvent('scalePhone.BuildApp', 'app_emailView', "emailView", "Rules", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_emails'}) --creating custom app for emails.

AddEventHandler('phone.ReceiveEmail', function(email)
    local mails = {title = email.title, to = email.to, from = email.from, message = email.message, event = 'phone.OpenEmail', canOpenMenu = false, selectEvent = ""}
    mails.eventParams = mails
    TriggerEvent('scalePhone.BuildAppButton', 'app_email', mails, true, -1)
    TriggerEvent('scalePhone.AddAppNotification', 'app_email')
end)

AddEventHandler('phone.ReceiveMessage', function(sms, isMine)
    local mess = {svID = sms.svID, contact = sms.contact, h = GetClockHours(), m = GetClockMinutes(), message = sms.message, event = 'phone.OpenMessage', isentthat = isMine, hasPic = sms.hasPic, canOpenMenu = true, selectEvent = "phone.OpenMessageOptions"}
    mess.eventParams = mess
    if sms.hasPic ~= nil then
        mess.hasPic = sms.hasPic
    end
    mess.eventParams.identifier = "/"..sms.contact.."/"..sms.message.."/"..tostring(isMine).."/" -- we set up a unique string in the message data, to make sure we can find it at a later stage.
    TriggerEvent('scalePhone.BuildAppButton', 'app_messages', mess, true, -1)
    if isMine == false then
        TriggerEvent('scalePhone.AddAppNotification', 'app_messages')
    end
end)

AddEventHandler('phone.OpenMessage', function(data)
    TriggerEvent('scalePhone.BuildMessageView', data, 'app_messageView')
    TriggerEvent('scalePhone.OpenApp', 'app_messageView', false) -- app '1000' is a prebuilt app for message viewing. It backs out to the last application opened. Doesn't have a menu.
end)

AddEventHandler('phone.OpenMessageOptions', function(data)
    TriggerEvent('scalePhone.BuildApp', 'app_message_options', "settings", data.contact, 5, 0, "", "scalePhone.GoBackApp", {backApp = 'app_messages'}) --you can build the app how many times you want. If it's the same appID, it will just overwrite it (and clear all buttons!)
    if tonumber(data.svID) ~= nil and tonumber(data.svID) > 0 then --if it's not a bot, add these buttons too.
        TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Reply", icon = 25, event = "phone.SendSMS", eventParams = {name = data.contact, isBot = false, svID = data.svID}}, false, -1) --Send a message back to the other player.
        TriggerEvent('scalePhone.BuildAppButton', 'app_message_options', {text = "Call "..data.contact, icon = 25, event = "phone.SendCall", eventParams = {name = data.contact, pic = data.hasPic, isBot = false, svID = data.svID}}, false, -1) --call the other player directly
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
    TriggerEvent('scalePhone.ResetAppButtons', 1) --first. We clear all contacts that we currently have.
    
    for i,k in pairs(contacts) do
        --local idc = {name = k.name, pic = k.pic, isBot = k.isBot, event = "eventName", eventParams = {name = k.name, isBot = k.isBot}}
        local idc = {name = k.name, pic = k.pic, isBot = k.isBot, event = "phone.OpenContactView", eventParams = {name = k.name, isBot = k.isBot, pic = k.pic, svID = k.svID}}
        if k.svID ~= nil then --if we got the server ID, or playerSrc, from the server, we include it in the eventParams. WE SHOULD GET IT, BY THE WAY.
            idc.eventParams.svID = k.svID
        end
        TriggerEvent('scalePhone.BuildAppButton', 'app_contacts', idc, k.isBot, -1) --adding the contact. If it's a bot, we add it at the top. 
    end

end)

TriggerEvent('scalePhone.BuildApp', 'call_screen', "callscreen", "Call", 4, 0, "", "phone.CloseCall", {backApp = 'app_contacts', contact = "unk", pic = "", status = "DIALING", canAnswer = false, selectEvent = ""})

AddEventHandler('phone.OpenContactView', function(data) --this is the contact view. Where we have multiple options, like calling or messaging.
    TriggerEvent('scalePhone.BuildApp', 'app_contact_view', "settings", data.name, 5, 0, "", "scalePhone.GoBackApp", {backApp = 'app_contacts'}) --you can build the app how many times you want. If it's the same appID, it will just overwrite it (and clear all buttons!)
    TriggerEvent('scalePhone.BuildAppButton', 'app_contact_view', {text = "Call", icon = 25, event = "phone.SendCall", eventParams = data}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_contact_view', {text = "Message", icon = 19, event = "phone.SendSMS", eventParams = data}, false, -1)
    if tonumber(data.svID) > 0 then --if it's not a bot, add these buttons too.
        --nothing here (yet!)
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
