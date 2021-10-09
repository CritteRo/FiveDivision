AddEventHandler('challenges.menu.OpenChallengeMainMenu', function()
    TriggerEvent('lobbymenu:CloseMenu')
    TriggerEvent('lobbymenu:CreateMenu', 'ch_main_0', "Active Challenges", "", "MENU~s~", "INFO", "")
    TriggerEvent('lobbymenu:SetHeaderDetails', 'ch_main_0', true, true, 123, 0, 0)
    TriggerEvent('lobbymenu:SetDetailsTitle', 'ch_main_0', "Details Title", 'sproffroad', 'spr_offroad_3')

    TriggerEvent('lobbymenu:SetTextBoxToColumn', 'ch_main_0', 3, "Challenges", "Throught San Andreas, the IAA set multiple tasks for the active agents.\n\nFrom liberating outposts, to completing missions, these challenges can change the way you play the game.", "")

    for i,k in pairs(sharedChallenges) do
        print(k.status)
        if k.status == 'active' then
            TriggerEvent('lobbymenu:AddButton', 'ch_main_0', {id = i}, string.format(sharedChallangeName[k.missionType][k.missionCondition1], k.missionCondition2), k.missionCondition3, false, 0, "challenges.menu.OpenChallengeMenu")
        end
    end
    TriggerEvent('lobbymenu:AddButton', 'ch_main_0', {id = 0, text = "Button Used"}, "Close Menu", "", false, 0, "lobbymenu:CloseMenu")

    TriggerEvent('lobbymenu:AddDetailsRow', 'ch_main_0', "Details Row 1", "~y~2 minutes~s~")
    Citizen.Wait(200)
    TriggerEvent('lobbymenu:OpenMenu', 'ch_main_0', true)
end)

RegisterCommand('challenges', function(source, args)
    TriggerEvent('challenges.menu.OpenChallengeMainMenu')
end)

AddEventHandler('challenges.menu.OpenChallengeMenu', function(_data)
    TriggerEvent('lobbymenu:CloseMenu')
    local _c = sharedChallenges[_data.id]
    local _p = {}
    if sharedChallengeUsers[_data.id] ~= nil then
        _p = sharedChallengeUsers[_data.id]
    end
    local players = 0
    local foundMe = nil
    local time = UnixToText(_c.missionEndUnix - sharedCurrentServerTime) --THIS IS STUPID!!! missionEndUnix IS BASED ON SERVER'S LOCAL TIME, AND os.time() clientside IS BASED ON CLIENT'S LOCAL TIME!!!!!!!!
    --This will probably need to run on UTC time only, both server and client. It would be an issue because we only need relative time, not absolute time, so it doesn't matter as long as both clients use the same timezone.

    TriggerEvent('lobbymenu:CreateMenu', 'ch_main_1', sharedChallangeTypeName[_c.type]..string.format(sharedChallangeName[_c.missionType][_c.missionCondition1], _c.missionCondition2), string.format(sharedChallengeShortDesc[_c.missionType][_c.missionCondition1][_c.missionCondition2], _c.missionCondition3), "MENU~s~", "TOP PLAYERS", "INFO")
    TriggerEvent('lobbymenu:SetHeaderDetails', 'ch_main_1', true, true, 123, 0, 0)
    TriggerEvent('lobbymenu:SetDetailsTitle', 'ch_main_1', "Details", 'sproffroad', 'spr_offroad_3')
    TriggerEvent('lobbymenu:AddDetailsRow', 'ch_main_1', "Time left:", time)

    if _c.missionType == 'outpost' and _c.missionCondition1 == 'liberate' then
        for i,k in pairs(_p) do
            --[pID] = {uid = 1[local id], pID = 32[players UID], name = "Console"[playername], challengeID = 0[challenge UID], dataPoint1 = 0, dataPoint2 = 0, dataPoint3 = 0},
            local colors = {123, 123}
            if k.pID == PlayerInfo.uid then
                colors = {116, 116}
                foundMe = k
            end
            TriggerEvent('lobbymenu:AddPlayer', 'ch_main_1', k.name, '', "Outposts Liberated: "..k.dataPoint1, 63, 0, true, colors[1], colors[2])
            players = players +1
        end
        if foundMe ~= nil then
            if (_c.missionCondition3 - foundMe.dataPoint1) >= 1 then
                TriggerEvent('lobbymenu:AddDetailsRow', 'ch_main_1', "Liberations needed:", (_c.missionCondition3 - foundMe.dataPoint1))
            else
                TriggerEvent('lobbymenu:AddDetailsRow', 'ch_main_1', "Mission Complete!")
            end
        else
            TriggerEvent('lobbymenu:AddDetailsRow', 'ch_main_1', "Liberations needed:", _c.missionCondition3)
        end
    end

    TriggerEvent('lobbymenu:AddButton', 'ch_main_1', {}, "Go Back", "", false, 0, "challenges.menu.OpenChallengeMainMenu")

    if players == 0 then
        TriggerEvent('lobbymenu:SetTextBoxToColumn', 'ch_main_1', 1, "Ooops", "Looks like nobody started working on this challenge.\n\nYou might want to come back here at a later time...\n\n...or maybe you can be first.", "No player data.")
    end
    Citizen.Wait(200)
    TriggerEvent('lobbymenu:OpenMenu', 'ch_main_1', true)
end)

function UnixToText(unix)
    local d = math.floor(unix / 86400)
    local h = math.floor((unix - d * 86400) / 3600)
    local m = math.floor((unix - (d * 86400) - (h * 3600)) / 60)
    local s = unix - (d * 86400) - (h * 3600) - (m * 60)
    local string = ""..s.." seconds"
    if unix >= 60 then
        string = ""..m.."min  ''"..s.."sec"
    end
    if unix >= 3600 then
        string = h.."h  "..m.."m  "..s.."s"
    end
    if unix >= 86400 then
        string = d.."day(s)   "..h.."h  "..m.."m  "..s.."s"
    end
    return string
end