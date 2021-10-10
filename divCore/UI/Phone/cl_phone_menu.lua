sleepMode = exports.scalePhone:sleepModeStatus()

AddEventHandler('scalePhone.Event.SleepModeChanged', function(state) --premade event. Called whenever Sleep Mode is toggled in the settings.
    sleepMode = state
    TriggerServerEvent('phone.sv.SetSleepMode', sleepMode)
end)

AddEventHandler('phone.ChangePhoneSize', function(size)
    exports.scalePhone:setPhoneDimensions(size)
    --[[
        exports.scalePhone:setPhoneDimensions(text, scale, x, y, z)
        text = "default", "custom", "small", "large" or "huge"
        if text == "custom" then you can use scale, x, y, z as params, to set the scale and coords of the frontend phone.
        you can use `local scale, x, y, z = exports.scalePhone:getPhoneDimensions()` to get the current phone dimensions.
    ]]
end)

--[[  ::  HOMEPAGE APPS  ::  ]]--
-- Order of events matters here. Every event will add a new app with the specified appID, and add the shortcut on the homepage. Only the first 9 apps will show on the homepage.
TriggerEvent('scalePhone.BuildHomepageApp', 'app_contacts', "contacts", "Contacts", 5, 0, "", "scalePhone.GoToHomepage", {}) -- 1
TriggerEvent('scalePhone.BuildHomepageApp', 'app_messages', "messagesList", "Messages", 2, 0, "", "scalePhone.GoToHomepage", {}) -- 2
TriggerEvent('scalePhone.BuildHomepageApp', 'app_emails', "emailList", "Emails", 4, 0, "", "scalePhone.GoToHomepage", {}) -- 3
TriggerEvent('scalePhone.BuildHomepageApp', 'app_numpad', "numpad", "Numpad", 27, 0, "", "scalePhone.GoToHomepage", {}) -- 4
TriggerEvent('scalePhone.BuildHomepageApp', 'app_gps', "gps", "GPS", 58, 0, "", "scalePhone.GoToHomepage", {}) -- 5

TriggerEvent('scalePhone.BuildHomepageApp', 'app_more', "settings", "More Apps", 6, 0, "", "scalePhone.GoToHomepage", {}) -- 6
TriggerEvent('scalePhone.BuildAppButton', 'app_more', {text = "Fast Travel to Outpost", icon = 0, event = "phone.StartFastTravel", eventParams = 'outpost'}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'app_more', {text = "Player Stats", icon = 23, event = "scalePhone.OpenApp", eventParams = 'app_stats'}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'app_more', {text = "Group Manager", icon = 23, event = "phone.OpenGroupMenu", eventParams = ''}, false, -1)

TriggerEvent('scalePhone.BuildHomepageApp', 'app_challenges', "todoList", "Active Challenges", 12, 0, "", "scalePhone.GoToHomepage", {}) -- 7
TriggerEvent('scalePhone.BuildSnapmatic', 'app_snapmatic') -- 8
TriggerEvent('scalePhone.BuildThemeSettings', 'app_settings') -- 9
TriggerEvent('scalePhone.BuildAppButton', 'app_settings', {text = "Phone Size", icon = 0, event = "scalePhone.OpenApp", eventParams = "settings_size"}, false, -1)

TriggerEvent('scalePhone.BuildApp', 'settings_size', 'settings', "Phone Size", 0,0,"", "scalePhone.GoBackApp", {backApp = 'app_settings'})
TriggerEvent('scalePhone.BuildAppButton', 'settings_size', {text = "Default", icon = 0, event = "phone.ChangePhoneSize", eventParams = 'default'}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'settings_size', {text = "Small", icon = 0, event = "phone.ChangePhoneSize", eventParams = 'small'}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'settings_size', {text = "Large", icon = 0, event = "phone.ChangePhoneSize", eventParams = 'large'}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'settings_size', {text = "Huge", icon = 0, event = "phone.ChangePhoneSize", eventParams = 'huge'}, false, -1)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--[[  ::  NUMPAD  ::  ]]--
--Here we are building the numpad buttons. This is pretty standard, so it doesn't really need a new file.
local pad = 0
numpadNumber = 0 -- we will use this variable to store our number, when we retrieve it from the framework.
for i=1,9,1 do
    pad = {text = i, event = "scalePhone.NumpadAddNumber", eventParams = {add = i}} --adding digits 1 to 9
    TriggerEvent('scalePhone.BuildAppButton', 'app_numpad', pad, false, -1)
end
pad = {text = 'RES', event = "scalePhone.NumpadAddNumber", eventParams = {add = 'res'}} -- "res" is predefined in the framework as a reset button. Only change the 'text' param, please.
TriggerEvent('scalePhone.BuildAppButton', 'app_numpad', pad, false, -1)
pad = {text = 0, event = "scalePhone.NumpadAddNumber", eventParams = {add = 0}} -- digit 0
TriggerEvent('scalePhone.BuildAppButton', 'app_numpad', pad, false, -1)
pad = {text = 'GO', event = "phone.UseNumpadNumber", eventParams = {add = 'go'}} -- 'go' is predefined in the framework as a select button. You use this to trigger the "event" event.
TriggerEvent('scalePhone.BuildAppButton', 'app_numpad', pad, false, -1)

AddEventHandler('scalePhone.Event.GetNumpadNumber', function(number) --predefined in the framework. Whenever you select a digit, this event will get triggered.
    numpadNumber = tonumber(number) --I think events sends only strings. So we make sure here that it's a number.
end)

AddEventHandler('phone.UseNumpadNumber', function() --triggered whenever you hit the 'go' button on numpad
    --[[
    if numpadNumber == 123 then
        --do stuff
    end 
    ]]
end)
----------------------------------------------------------------------------------------------------------------

--[[  ::  MORE APPS  ::  ]]--

-----Stats Menu. This will get rebuilt by core.GetInitialStats and core.UpdateClientResources anyway..but we need a default one.
TriggerEvent('scalePhone.BuildApp', 'app_stats', 'missionStatsView', "Player Stats", 0,0,"", "scalePhone.GoBackApp", {backApp = 'app_more'})
TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Level ", subtitle = ""}, false, -1)

AddEventHandler('core.UpdateClientResources', function(_info)
    TriggerEvent('scalePhone.ResetAppButtons', 'app_stats')

    --[[HEADER]]TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Level ".._info.stats['level'], subtitle = _info.name}, false, -1)
     
    --[[buttons]]--
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "UID  //  ".._info.uid, subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "ARank  //  ".._info.admin, subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "GroupID  //  ".._info.group, subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Cash  //  ".._info.stats['cash'], subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Bank  //  ".._info.stats['bank'], subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Coins  //  ".._info.stats['coins'], subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "XP  //  ".._info.stats['xp'], subtitle = ""}, false, -1)

    --[[FOOTER]]TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Player Stats", subtitle = ""}, false, -1)
end)

AddEventHandler('core.GetInitialStats', function(_info)
    TriggerEvent('scalePhone.ResetAppButtons', 'app_stats')

    --[[HEADER]]TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Level ".._info.stats['level'], subtitle = _info.name}, false, -1)
     
    --[[buttons]]--
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "UID  //  ".._info.uid, subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "ARank  //  ".._info.admin, subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Cash  //  ".._info.stats['cash'], subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Bank  //  ".._info.stats['bank'], subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Coins  //  ".._info.stats['coins'], subtitle = ""}, false, -1)
    TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "XP  //  ".._info.stats['xp'], subtitle = ""}, false, -1)

    --[[FOOTER]]TriggerEvent('scalePhone.BuildAppButton', 'app_stats', {title = "Player Stats", subtitle = ""}, false, -1)
end)


--GROUP MENU. This is where you should be able to leave the group, or see other members.
TriggerEvent('scalePhone.BuildApp', 'app_group_members', "contacts", "Members", 0, 0, "", "scalePhone.GoBackApp", {backApp = 'app_group_main'})
TriggerEvent('scalePhone.BuildApp', 'app_group_colors', "settings", "Group Colors", 0, 0, "", "scalePhone.GoBackApp", {backApp = 'app_group_main'})
TriggerEvent('scalePhone.BuildAppButton', 'app_group_colors', {text = "Black", icon = 23, event = "phone.ChangeGroupSetting", eventParams = {type = "color", colID = 2}}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'app_group_colors', {text = "Yellow", icon = 23, event = "phone.ChangeGroupSetting", eventParams = {type = "color", colID = 12}}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'app_group_colors', {text = "Red", icon = 23, event = "phone.ChangeGroupSetting", eventParams = {type = "color", colID = 6}}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'app_group_colors', {text = "Green", icon = 23, event = "phone.ChangeGroupSetting", eventParams = {type = "color", colID = 18}}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'app_group_colors', {text = "Gray", icon = 23, event = "phone.ChangeGroupSetting", eventParams = {type = "color", colID = 4}}, false, -1)
TriggerEvent('scalePhone.BuildAppButton', 'app_group_colors', {text = "Pink", icon = 23, event = "phone.ChangeGroupSetting", eventParams = {type = "color", colID = 24}}, false, -1)
AddEventHandler('phone.OpenGroupMenu', function()
    if PlayerInfo.group ~= 0 then
        TriggerEvent('scalePhone.BuildApp', 'app_group_main', 'settings', "Group Manager", 0,0,"", "scalePhone.GoBackApp", {backApp = 'app_more'})
        TriggerEvent('scalePhone.BuildAppButton', 'app_group_main', {text = "Members", icon = 0, event = "scalePhone.OpenApp", eventParams = 'app_group_members'}, false, -1)
        if PlayerInfo.isGroupLeader == true then
            TriggerEvent('scalePhone.BuildAppButton', 'app_group_main', {text = "Change group color", icon = 0, event = "scalePhone.OpenApp", eventParams = 'app_group_colors'}, false, -1)
            TriggerEvent('scalePhone.BuildAppButton', 'app_group_main', {text = "Change group name", icon = 0, event = "phone.ChangeGroupSetting", eventParams = {type = "name"}}, false, -1)
        end
        TriggerEvent('scalePhone.BuildAppButton', 'app_group_main', {text = "Leave Group", icon = 0, event = "phone.LeaveGroup", eventParams = ''}, false, -1)
    else
        TriggerEvent('scalePhone.BuildApp', 'app_group_main', "messageView", "Group Manager", 0, 0, "", 'scalePhone.GoBackApp', {backApp = 'app_more', contact = "Server", message = 'You are not part of any group.', fromme = false, hasPic = "", canOpenMenu = false, selectEvent = ""})
    end
    TriggerEvent('scalePhone.OpenApp', 'app_group_main', false)
end)

AddEventHandler('phone.OpenGroupMemberView', function(data)
    TriggerEvent('scalePhone.BuildApp', 'app_group_member_view', "settings", data.name, 5, 0, "", "scalePhone.GoBackApp", {backApp = 'app_group_members'}) --you can build the app how many times you want. If it's the same appID, it will just overwrite it (and clear all buttons!)
    TriggerEvent('scalePhone.BuildAppButton', 'app_group_member_view', {text = "Message", icon = 19, event = "phone.SendSMS", eventParams = data}, false, -1)
    if PlayerInfo.isGroupLeader == true then
        TriggerEvent('scalePhone.BuildAppButton', 'app_group_member_view', {text = "Kick", icon = 27, event = "phone.KickMemberFromGroup", eventParams = data}, false, -1)
    end

    TriggerEvent('scalePhone.OpenApp', 'app_group_member_view', false) --at the end, we open the app.
end)

-- FAST TRAVEL
AddEventHandler('phone.StartFastTravel', function(_type)
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
        if _type == "outpost" then
            TriggerServerEvent('outpost.TeleportToOutpost', {x = waypointCoords['x'], y = waypointCoords['y']})
        end
    else
        print('no waypoint')
    end
end)