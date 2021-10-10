RegisterCommand("cc", function(source, args)
    local src = source
    if PlayerInfo[src].admin >=2 then
        TriggerClientEvent("chat:clear", -1)
    else
        local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
        TriggerClientEvent('core.notify', src, _notif.type, _notif)
    end
end)

RegisterCommand("tpw", function(source, args)
    local src = source
    if PlayerInfo[src].admin >=2 then
        TriggerClientEvent("core.tpToWaypoint", source)
    else
        local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
        TriggerClientEvent('core.notify', src, _notif.type, _notif)
    end
end)

RegisterCommand('tpc', function(source, args)
    local src = source
    if PlayerInfo[src].admin >=2 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil and tonumber(args[3]) ~= nil then
            local coords = vector3(tonumber(args[1]) +0.00001, tonumber(args[2]) +0.00001, tonumber(args[3]) +0.00001)
            SetEntityCoords(GetPlayerPed(src), coords.x, coords.y, coords.z, false, false, false, false)
            local _notif = {type = "simple", text = "Teleported to location.", colID = 2}
            TriggerClientEvent('core.notify', src, _notif.type, _notif)
        end
    else
        local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
        TriggerClientEvent('core.notify', src, _notif.type, _notif)
    end
end)

RegisterCommand('goto', function(source, args)
    local src = source
    if PlayerInfo[src].admin >=2 then
        if tonumber(args[1]) ~= nil then
            local pid = tonumber(args[1])
            if GetPlayerPing(pid) ~= 0 then
                local pCoords = GetEntityCoords(GetPlayerPed(pid))
                SetEntityCoords(GetPlayerPed(src), pCoords.x, pCoords.y, pCoords.z, false, false, false, false)
                --TriggerClientEvent('cmd.tpToPlayer', src, pCoords)
                _notif = {
                    type = "simple",
                    text = "Teleporting to ~y~"..GetPlayerName(pid).."~s~."
                }
                TriggerClientEvent("core.notify", src, _notif.type, _notif)
            end
        end
    else
        local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
        TriggerClientEvent('core.notify', src, _notif.type, _notif)
    end
end)

RegisterCommand('gethere', function(source, args)
    local src = source
    if PlayerInfo[src].admin >=2 then
        if tonumber(args[1]) ~= nil then
            local pid = tonumber(args[1])
            if GetPlayerPing(pid) ~= 0 then
                local pCoords = GetEntityCoords(GetPlayerPed(src))
                SetEntityCoords(GetPlayerPed(pid), pCoords.x, pCoords.y, pCoords.z, false, false, false, false)
                --TriggerClientEvent('cmd.tpToPlayer', pid, pCoords)
                _notif = {
                    type = "simple",
                    text = "Getting ~y~"..GetPlayerName(pid).."~s~ here."
                }
                TriggerClientEvent("core.notify", src, _notif.type, _notif)

                _notif = {
                    type = "simple",
                    text = "~y~"..GetPlayerName(src).."~s~ teleported you to them."
                }
                TriggerClientEvent("core.notify", pid, _notif.type, _notif)
            end
        end
    else
        local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
        TriggerClientEvent('core.notify', src, _notif.type, _notif)
    end
end)

RegisterCommand("ban", function(source, args)
    local src = source
    if PlayerInfo[src].admin >= 2 then
        if args[1] ~= nil then
            if GetPlayerPing(tonumber(args[1])) ~= 0 then
                if args[2] ~= nil then
                    TriggerClientEvent('cS.MidsizeBanner', -1, "BANNED", 'for '..tonumber(args[2])..' days.', 8, 5, true)
                    exports.oxmysql:execute("UPDATE `users` SET `bantime` = ? WHERE `uid` = ?",{tonumber(args[2]), PlayerInfo[tonumber(args[1])].uid}, function(affectedRows) end)
                    Citizen.CreateThread(function()
                        Citizen.Wait(5000)
                        DropPlayer(tonumber(args[1]), "You got banned for "..tonumber(args[2]).." days.")
                    end)
                else
                    TriggerClientEvent('cS.MidsizeBanner', -1, "BANNED", 'permanently.', 8, 5, true)
                    exports.oxmysql:execute("UPDATE `users` SET `bantime` = -1 WHERE `uid` = ?",{PlayerInfo[tonumber(args[1])].uid}, function(affectedRows) end)
                    Citizen.CreateThread(function()
                        Citizen.Wait(5000)
                        DropPlayer(tonumber(args[1]), "You got permanently banned.")
                    end)
                end
                print(string.format("%s(%i) banned by %s(%i).", GetPlayerName(tonumber(args[1])), tonumber(args[1]), GetPlayerName(src), src))
            else
                print("wrond id")
            end
        else
            print("wrong syntax")
        end
    else
        local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
        TriggerClientEvent('core.notify', src, _notif.type, _notif)
    end
end)

RegisterCommand("kick", function(source, args)
    local src = source
    if PlayerInfo[src].admin >= 2 then
        if args[1] ~= nil then
            if GetPlayerPing(tonumber(args[1])) ~= 0 then
                print(string.format("%s(%i) kicked by %s(%i).", GetPlayerName(tonumber(args[1])), tonumber(args[1]), GetPlayerName(src), src))
                if args[2] ~= nil then
                    local _message = ""
                    for k, v in pairs(args) do
                        if k ~= nil then
                            if k >= 2 then
                                _message = string.format("%s %s", _message, tostring(args[k]))
                            end
                        else
                            break
                        end
                    end
                    DropPlayer(args[1], 'You got kicked by an admin. Reason: '.._message)
                else
                    DropPlayer(args[1], "You got kicked by an admin.")
                end
            else
                print("wrond id")
            end
        else
            print("wrong syntax")
        end
    else
        local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
        TriggerClientEvent('core.notify', src, _notif.type, _notif)
    end
end)

RegisterCommand("tmute", function(source, args)
    local src = source
    if PlayerInfo[src].admin >= 2 then
        if args[1] ~= nil and args[2] ~= nil then
            if GetPlayerPing(tonumber(args[1])) ~= 0 then
                if args[2] ~= nil then
                    PlayerInfo[tonumber(args[1])].mutetime = tonumber(args[2])
                else
                    PlayerInfo[tonumber(args[1])].mutetime = 1
                end
                print(string.format("%s(%i) muted by %s(%i).", GetPlayerName(tonumber(args[1])), tonumber(args[1]), GetPlayerName(src), src))
            else
                print("wrond id")
            end
        else
            local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
            TriggerClientEvent('core.notify', src, _notif.type, _notif)
        end
    end
end)

RegisterCommand('announce', function(source, args)
    local src = source
    if src == 0 or PlayerInfo[src].admin >= 3 then
        if args[1] ~= nil then
            local string = ""
            local count = 0
            local time = 5
            for i,k in pairs(args) do
                string = string.." "..k
                count = count + 1
            end
            time = time + (count * 0.33)
            TriggerClientEvent('cS.MidsizeBanner', -1, "MOD MESSAGE", string, 2, time, true)
            local email = {title = 'Mod message from '..GetPlayerName(src), to = 'everyone', from = "admins@lslockdown", message = string}
            TriggerClientEvent('phone.ReceiveEmail', -1, email)
        else
            local _notif = {type = "simple", text = "You need to write something.", colID = 8}
            TriggerClientEvent('core.notify', src, _notif.type, _notif)
        end
    else
        local _notif = {type = "simple", text = "You don't have the required permissions", colID = 8}
        TriggerClientEvent('core.notify', src, _notif.type, _notif)
    end
end)
