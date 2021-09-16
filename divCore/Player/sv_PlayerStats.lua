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

AddEventHandler('core.ChangePlayerInfo', function(_infoType, _src, _imp, )

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