RegisterNetEvent('core.PlayerIsChangingClothes')
RegisterNetEvent('core.UpdatePlayerClothesVariations')
RegisterNetEvent('core.SetPlayerCosmeticItem')
RegisterNetEvent('baseevents:onPlayerDied')

PlayerInfo = {
    [0] = {
        uid = 0,
        name = "console",
        bantime = 0,
        mutetime = 0,
        stats = {},
        weapons = {},
        clothes = {},
        ped = {},
        lang = 'en',
        admin = 0,
        license = "license:99999999999999999",
        activity = 0,
        group = 0,
    }
}

RegisterCommand("setcomp", function(source, args)
    local src = source
    if true then
        local _comp = {
            id = tonumber(args[1]),
            drid = tonumber(args[2]),
            txid = tonumber(args[3])
        }
        TriggerClientEvent('char.ForceCharacterComponent', src, _comp)
    end
end)

RegisterCommand('giveclothes', function(source, args)
    local src = source
    if PlayerInfo[src] ~= nil and PlayerInfo[src].clothes ~= nil and tonumber(args[1]) then
        local alreadyHaveIt = false
        for i,k in pairs(PlayerInfo[src].clothes) do
            if k == tonumber(args[1]) then
                alreadyHaveIt = true
                break
            end
        end
        if alreadyHaveIt == false then
            PlayerInfo[src].clothes[#PlayerInfo[src].clothes + 1] = tonumber(args[1])
        end
        for i,k in pairs(cosmeticClothes[tonumber(args[1])][PlayerInfo[src].ped['model']]) do
            PlayerInfo[src].ped[k[1]] = {k[2], 0}
        end
        TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src])
        TriggerEvent('core.UpdateServerResources', src, PlayerInfo[src])
        updateClothesInDatabase(src, PlayerInfo[src].uid)
    end
end)

RegisterCommand('addclothing', function(source, args)
    local src = source
    TriggerEvent('core.ChangePlayerInfo', 'clothes', 'Core/sv_PlayerStats.lua', src, tonumber(args[1]), true, true)
end)

RegisterCommand('addweapon', function(source, args)
    local src = source
    TriggerEvent('core.ChangePlayerInfo', 'weapons', 'Core/sv_PlayerStats.lua', src, tostring(args[1]), true, true)
end)

RegisterCommand('addwmod', function(source, args)
    local src = source
    TriggerEvent('core.ChangePlayerInfo', 'weaponmods', 'Core/sv_PlayerStats.lua', src, tostring(args[1]), true, true)
end)

RegisterCommand('addstat', function(source, args)
    local src = source
    TriggerEvent('core.ChangePlayerInfo', 'stats', 'Core/sv_PlayerStats.lua', src, tostring(args[1]), tonumber(args[2]), true)
end)

AddEventHandler('core.UpdatePlayerClothesVariations', function(comp11, comp8, comp6, comp4)
    local src = source
    PlayerInfo[src].ped['comp11'][2] = comp11
    PlayerInfo[src].ped['comp8'][2] = comp8
    PlayerInfo[src].ped['comp6'][2] = comp6
    PlayerInfo[src].ped['comp4'][2] = comp4
    updateClothesInDatabase(src, PlayerInfo[src].uid)
    TriggerClientEvent('core.UpdatePlayerPed', src, PlayerInfo[src].ped)
end)

AddEventHandler('core.SetPlayerCosmeticItem', function(_id)
    local src = source
    if tonumber(_id) ~= nil then
        for i,k in pairs(PlayerInfo[src].clothes) do
            if k == tonumber(_id) then
                for i,k in pairs(cosmeticClothes[k][PlayerInfo[src].ped['model']]) do
                    PlayerInfo[src].ped[k[1]] = {k[2], 0}
                end
                updateClothesInDatabase(src, PlayerInfo[src].uid)
                TriggerClientEvent('core.UpdatePlayerPed', src, PlayerInfo[src].ped)
                TriggerClientEvent('core.notify', src, "simple", {text = "Item ~y~"..cosmeticClothes[k][PlayerInfo[src].ped['model']][1][3].."~s~ equipped successfully."})
                break
            end
        end
    end
end)


function updateClothesInDatabase(src, uid)
    if GetPlayerPing(src) ~= 0 then
        if PlayerInfo[src] ~= nil and PlayerInfo[src].clothes ~= nil and PlayerInfo[src].ped then
            exports.oxmysql:execute("UPDATE `users` SET `clothes` = ?, `ped` = ? WHERE `uid` = ?",{json.encode(PlayerInfo[src].clothes), json.encode(PlayerInfo[src].ped), uid}, function(affectedRows)
                if affectedRows >= 1 then
                    print('Clothes and ped saved for ['..src..']'..GetPlayerName(src)..'')
                end
            end)
        end
    end
end

function updateStatsInDatabase(src, uid)
    if GetPlayerPing(src) ~= 0 then
        if PlayerInfo[src] ~= nil and PlayerInfo[src].stats ~= nil then
            exports.oxmysql:execute("UPDATE `users` SET `stats` = ? WHERE `uid` = ?",{json.encode(PlayerInfo[src].stats), uid}, function(affectedRows)
                if affectedRows >= 1 then
                    print('Stats saved for ['..src..']'..GetPlayerName(src)..'')
                end
            end)
        end
    end
end

function updateWeaponsInDatabase(src, uid)
    if GetPlayerPing(src) ~= 0 then
        if PlayerInfo[src] ~= nil and PlayerInfo[src].weapons ~= nil then
            exports.oxmysql:execute("UPDATE `users` SET `weapons` = ? WHERE `uid` = ?",{json.encode(PlayerInfo[src].weapons), uid}, function(affectedRows)
                if affectedRows >= 1 then
                    print('Weapons saved for ['..src..']'..GetPlayerName(src)..'')
                end
            end)
        end
    end
end

AddEventHandler('core.ChangePlayerInfo', function(_infoType, _initiator, _src, _stat, _value, _prioritySave)
    local srce = tonumber(source)
    local player = tonumber(_src)
    if --[[srce < 1]]true then
        if GetPlayerPing(player) ~= 0 and PlayerInfo[player] ~= nil then
            if _infoType == "clothes" then --stat will be the item ID. _value will be true or false. True = add clothing item. False = remove clothing item.
                local foundId = nil
                local lastId = 0
                for i,k in pairs(PlayerInfo[player].clothes) do --looking through player's wardrobe
                    if k == tonumber(_stat) then
                        foundId = i
                    end
                    if PlayerInfo[player].clothes[i+1] ~= nil then
                    else
                        lastId = i
                    end
                end
                if foundId ~= nil then --if we found _stat
                    if _value == false then --should we remove it?
                        PlayerInfo[player].clothes[foundId] = nil
                        TriggerClientEvent('core.notify', player, "unlock", {title = "Item Removed", text = cosmeticClothes[tonumber(_stat)][PlayerInfo[player].ped['model']][1][3], icontype = 7, colID = 8})
                        TriggerClientEvent('core.UpdateClientResources', player, PlayerInfo[player], false)
                        TriggerEvent('core.UpdateServerResources', player, PlayerInfo[player])
                        updateClothesInDatabase(player, PlayerInfo[player].uid)
                    end
                else -- if we didn't find it
                    if _value == true then --should we add it?
                        if cosmeticClothes[tonumber(_stat)] ~= nil then
                            PlayerInfo[player].clothes[lastId+1] = tonumber(_stat)
                            TriggerClientEvent('core.notify', player, "unlock", {title = "Item Added", text = cosmeticClothes[tonumber(_stat)][PlayerInfo[player].ped['model']][1][3], icontype = 7, colID = 123})
                            TriggerClientEvent('core.UpdateClientResources', player, PlayerInfo[player], false)
                            TriggerEvent('core.UpdateServerResources', player, PlayerInfo[player])
                            updateClothesInDatabase(player, PlayerInfo[player].uid)
                        else
                            print('[ ERROR IN core.ChangePlayerInfo :: Incorrect clothes _stat requested by "'.._initiator..'"]')
                        end
                    end
                end
            elseif _infoType == "stats" then
                if PlayerInfo[player].stats[_stat] ~= nil then
                    PlayerInfo[player].stats[_stat] = _value
                    TriggerClientEvent('core.UpdateClientResources', player, PlayerInfo[player], true)
                    TriggerEvent('core.UpdateServerResources', player, PlayerInfo[player])
                    updateStatsInDatabase(player, PlayerInfo[player].uid)
                else
                    print('[ ERROR IN core.ChangePlayerInfo :: Incorrect stats _stat requested by "'.._initiator..'"]')
                end
            elseif _infoType == "weapons" then
                if PlayerInfo[player].weapons[_stat] ~= nil then
                    if _value == true then
                        if PlayerInfo[player].weapons[_stat]['gun'][2] == false then
                            PlayerInfo[player].weapons[_stat]['gun'][2] = _value
                            TriggerClientEvent('core.UpdateClientResources', player, PlayerInfo[player], false)
                            TriggerEvent('core.UpdateServerResources', player, PlayerInfo[player])
                            TriggerClientEvent('core.notify', player, "unlock", {title = "Weapon Added", text = PlayerInfo[player].weapons[_stat]['gun'][3], icontype = 2, colID = 123})
                            updateWeaponsInDatabase(player, PlayerInfo[player].uid)
                        end
                    elseif _value == false then
                        if PlayerInfo[player].weapons[_stat]['gun'][2] == true then
                            PlayerInfo[player].weapons[_stat]['gun'][2] = _value
                            TriggerClientEvent('core.UpdateClientResources', player, PlayerInfo[player], false)
                            TriggerEvent('core.UpdateServerResources', player, PlayerInfo[player])
                            TriggerClientEvent('core.notify', player, "unlock", {title = "Weapon Removed", text = PlayerInfo[player].weapons[_stat]['gun'][3], icontype = 2, colID = 8})
                            updateWeaponsInDatabase(player, PlayerInfo[player].uid)
                        end
                    else
                        print('[ ERROR IN core.ChangePlayerInfo :: Incorrect weapons _value requested by "'.._initiator..'"]')
                    end
                else
                    print('[ ERROR IN core.ChangePlayerInfo :: Incorrect weapons _stat requested by "'.._initiator..'"]')
                end
            elseif _infoType == "weaponmods" then
                local foundId = nil
                for i,k in pairs(PlayerInfo[player].weapons) do
                    if k[_stat] ~= nil then
                        foundId = i
                        break
                    end
                end
                if foundId ~= nil then
                    if PlayerInfo[player].weapons[foundId][_stat] ~= nil then
                        if _value == true then
                            if PlayerInfo[player].weapons[foundId][_stat][2] == false then
                                PlayerInfo[player].weapons[foundId][_stat][2] = _value
                                TriggerClientEvent('core.UpdateClientResources', player, PlayerInfo[player], false)
                                TriggerEvent('core.UpdateServerResources', player, PlayerInfo[player])
                                TriggerClientEvent('core.notify', player, "unlock", {title = "Weapon Mod Added", text = PlayerInfo[player].weapons[foundId][_stat][3], icontype = 3, colID = 123})
                                updateWeaponsInDatabase(player, PlayerInfo[player].uid)
                            end
                        elseif _value == false then
                            if PlayerInfo[player].weapons[foundId][_stat][2] == true then
                                PlayerInfo[player].weapons[foundId][_stat][2] = _value
                                TriggerClientEvent('core.UpdateClientResources', player, PlayerInfo[player], false)
                                TriggerEvent('core.UpdateServerResources', player, PlayerInfo[player])
                                TriggerClientEvent('core.notify', player, "unlock", {title = "Weapon Mod Removed", text = PlayerInfo[player].weapons[foundId][_stat][3], icontype = 3, colID = 123})
                                updateWeaponsInDatabase(player, PlayerInfo[player].uid)
                            end
                        else
                            print('[ ERROR IN core.ChangePlayerInfo :: Incorrect weaponmods _value requested by "'.._initiator..'"]')
                        end
                    end
                else
                    print('[ ERROR IN core.ChangePlayerInfo :: Incorrect weaponmods _stat requested by "'.._initiator..'"]')
                end
            elseif _infoType == "other" then
            else
                print('[ ERROR IN core.ChangePlayerInfo :: Incorrect _infoType requested by "'.._initiator..'"]')
            end
        end
    end
end)

AddEventHandler('core.PlayerIsChangingClothes', function(data)
    local src = source
    if PlayerInfo[src] ~= nil and PlayerInfo[src].clothes ~= nil then
        print('looking through clothes inventory')
        for i,k in pairs(PlayerInfo[src].clothes) do
            if k == data.id then
                print('found it!')
                break
            end
        end
    end
end)

AddEventHandler("baseevents:onPlayerDied", function(killedBy, pos)
    local victim = source
        local message = ""
        local wTime = 5
        print(string.format("%s died.", GetPlayerName(victim)))
        TriggerClientEvent("core.banner", victim, "~r~WASTED~s~", message, wTime)
        TriggerClientEvent("core.respawn", victim)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local name = GetPlayerName(src)
    local _time = {
        h = tonumber(os.date("%H")),
        m = tonumber(os.date("%M")),
    }
    print("[".._time.h..":".._time.m.."]"..name.." dropped ("..reason..").")
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        TriggerEvent('core.GatherPlayersForScoreboard')
    end)
end)