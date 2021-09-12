RegisterNetEvent('core.PlayerIsChangingClothes')
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


function updateClothesInDatabase(src, uid)
    if GetPlayerPing(src) ~= 0 then
        if PlayerInfo[src] ~= nil and PlayerInfo[src].clothes ~= nil and PlayerInfo[src].ped then
            exports.oxmysql:execute("INSERT INTO users (clothes, ped) VALUES(?, ?) WHERE `uid` = ?",{json.encode(PlayerInfo[src].clothes), json.encode(PlayerInfo[src].ped), uid}, function(affectedRows)
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
            exports.oxmysql:execute("INSERT INTO users (stats) VALUES(?) WHERE `uid` = ?",{json.encode(PlayerInfo[src].stats), uid}, function(affectedRows)
                if affectedRows >= 1 then
                    print('Stats saved for ['..src..']'..GetPlayerName(src)..'')
                end
            end)
        end
    end
end

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