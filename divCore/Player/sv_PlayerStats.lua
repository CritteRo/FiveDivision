PlayerInfo = {
    [0] = {
        uid = 0,
        name = "console",
        bantime = 0,
        mutetime = 0,
        stats = {},
        weapons = {},
        clothes = {},
        char = {},
        lang = 'en',
        admin = 0,
        license = "license:99999999999999999",
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

RegisterCommand('player_sv', function(source, args)
end)