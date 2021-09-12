defaultStats = {
    ['level'] = 1,
    ['xp'] = 0,
    ['cash'] = 1000,
    ['bank'] = 0,
    ['coins'] = 0,
}

defaultChar = {
    ['model'] = 'mp_m_freemode_01',
    ['blend'] = {21,0,1.0,1.0}, --motherID, fatherID, shapeMix, skinMix,
    ['hair'] = {1, 255, 1, 255, 0}, --head hair, facial hair, eyebrows, chest hair, hair color.
    ['overlay'] = {255, 255, 255, 0, 255, 0, 255, 255, 255, 0, 255}, --blemishes, ageing, makeup, makeupColor, blush, blushColor, complexion, sun damage, lipstick, lipstickColor, moles
    ['comp1'] = {0,0},
    ['comp2'] = {1,0},
    ['comp3'] = {1,0},
    ['comp4'] = {9,7},
    ['comp5'] = {0,0},
    ['comp6'] = {25,0},
    ['comp7'] = {0,0}, --125,0
    ['comp8'] = {32,0},
    ['comp9'] = {0,0}, --54,0
    ['comp10'] = {0,0}, --8,0
    ['comp11'] = {167,3},
    ['prop0'] = {-1,0}, -- -1 = no prop
    ['prop1'] = {-1,0},
    ['prop2'] = {-1,0},
    ['prop6'] = {-1,0},
    ['prop7'] = {-1,0},
}

defaultClothes = {} --this will be empty at first, but it will contain all player cosmetics ids. ex: {4,5,76,2,567}

defaultWeapons = {

}


local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local identifiers = GetPlayerIdentifiers(player)

    local license  = false

    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
            --print(licence)
        end
        
    end


    deferrals.defer()
    -- mandatory wait!
    Wait(0)
    deferrals.update(string.format(deferralsText['all_checklocation'], name))
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    -- mandatory wait!
    Wait(0)
    if false then
        deferrals.done(deferralsText['all_invalidLicense'])
    else
        deferrals.update(deferralsText['all_findAccount'])
        exports.oxmysql:fetch("SELECT COUNT(uid) AS idcount FROM users WHERE `name` = ?", {name}, function(result) --numara conturile cu numele asta
            if result[1]['idcount'] == 1 then --daca exista steamid => exista un cont cu numele ala
                local send = 1
                ---------
                exports.oxmysql:fetch("SELECT * FROM `users` WHERE `name` = ?",{name},function (result)
                    if result[1].license == license then
                        if result[1].bantime == 0 then
                            print(string.format("Logged in with %s", tostring(license)))
                            --TriggerEvent("stats.GetPlayerStats", name)
                            deferrals.done()
                        else
                            if result[1].bantime == -1 then
                                deferrals.done(deferralsText['all_checkBan_permanent'])
                            elseif result[1].bantime > 0 then
                                deferrals.done(string.format(deferralsText['all_checkBan_temp'], tonumber(result[1].bantime)))
                            end
                        end
                    else
                        deferrals.done(deferralsText['all_invalidLicense'])
                    end
                end)
                ---------
            else --daca nu exista cont cu numele asta
                local send = 0
                deferrals.done()
                exports.oxmysql:fetch("INSERT INTO users (name, stats, weapons, clothes, ped, license) VALUES(?, ?, ?, ?, ?, ?)",
                            {name, json.encode(defaultStats), json.encode(defaultWeapons), json.encode(defaultClothes), json.encode(defaultChar), license},
                            function (result)
                            end)
            end
        end)
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)