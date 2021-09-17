tempData = {}

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local identifiers = GetPlayerIdentifiers(player)

    local license  = false

    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
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
                            tempData[tonumber(player)] = {
                                uid = result[1].uid,
                                name = result[1].name,
                                bantime = result[1].bantime,
                                mutetime = result[1].mutetime,
                                stats = json.decode(result[1].stats),
                                weapons = json.decode(result[1].weapons),
                                clothes = json.decode(result[1].clothes),
                                ped = json.decode(result[1].ped),
                                lang = result[1].lang,
                                admin = result[1].admin,
                                license = result[1].license,
                                activity = 0,
                                group = 0,
                            }
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
                exports.oxmysql:fetch("INSERT INTO users (name, stats, weapons, clothes, ped, license) VALUES(?, ?, ?, ?, ?, ?)",
                            {name, json.encode(defaultStats), json.encode(defaultWeapons), json.encode(defaultClothes), json.encode(defaultChar), license},
                            function (result)
                                exports.oxmysql:fetch("SELECT * FROM `users` WHERE `name` = ?",{name},function (result)
                                    if result[1].license == license then
                                        if result[1].bantime == 0 then
                                            print(string.format("Signed in with %s", tostring(license)))
                                            tempData[tonumber(player)] = {
                                                uid = result[1].uid,
                                                name = result[1].name,
                                                bantime = result[1].bantime,
                                                mutetime = result[1].mutetime,
                                                stats = json.decode(result[1].stats),
                                                weapons = json.decode(result[1].weapons),
                                                clothes = json.decode(result[1].clothes),
                                                ped = json.decode(result[1].ped),
                                                lang = result[1].lang,
                                                admin = result[1].admin,
                                                license = result[1].license,
                                                activity = 0,
                                                group = 0,
                                            }
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
                            end)
            end
        end)
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

AddEventHandler('playerJoining', function(oldID)
    local src = source
    PlayerInfo[src] = tempData[tonumber(oldID)]
    TriggerClientEvent('core.GetInitialStats', src, PlayerInfo[src])
    TriggerEvent('core.GatherPlayersForScoreboard')
    tempData[tonumber(oldID)] = nil
end)

defaultStats = {
    ['level'] = 1,
    ['xp'] = 0,
    ['cash'] = 1000,
    ['bank'] = 0,
    ['coins'] = 0,
    ['firstLogin'] = 1,
}

defaultChar = {
    ['model'] = 'mp_m_freemode_01',
    ['blend'] = {21,0,1.0,1.0}, --motherID, fatherID, shapeMix, skinMix,
    ['hair'] = {1, 255, 1, 255, 0}, --head hair, facial hair, eyebrows, chest hair, hair color.
    ['overlay'] = {255, 255, 255, 0, 255, 0, 255, 255, 255, 0, 255}, --blemishes, ageing, makeup, makeupColor, blush, blushColor, complexion, sun damage, lipstick, lipstickColor, moles
    ['comp1'] = {0,0},
    ['comp2'] = {2,0},
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

defaultClothes = {1,2,3,4} --Contains default cosmetics ids.

defaultWeapons = {
    ['pistol'] = {
        ['gun'] = {'pistol', false, "Pistol"},
        ['COMPONENT_PISTOL_CLIP_01'] = {'COMPONENT_PISTOL_CLIP_01', true, 'Pistol Default Clip', true},
        ['COMPONENT_PISTOL_CLIP_02'] = {'COMPONENT_PISTOL_CLIP_02', false, "Pistol Extended Clip", false},
        ['COMPONENT_AT_PI_FLSH'] = {'COMPONENT_AT_PI_FLSH', false, "Pistol Flashlight", false},
        ['COMPONENT_AT_PI_SUPP_02'] = {'COMPONENT_AT_PI_SUPP_02', false, "Pistol Suppressor", false},
    },
    ['combatpistol'] = {
        ['gun'] = {'combatpistol', false, "Combat Pistol"},
        ['COMPONENT_COMBATPISTOL_CLIP_01'] = {'COMPONENT_COMBATPISTOL_CLIP_01', true, "CPistol Default Clip", true},
        ['COMPONENT_COMBATPISTOL_CLIP_02'] = {'COMPONENT_COMBATPISTOL_CLIP_02', false, "CPistol Extended Clip", true},
        ['COMPONENT_AT_PI_FLSH'] = {'COMPONENT_AT_PI_FLSH', false, "CPistol Flashlight", false},
        ['COMPONENT_AT_PI_SUPP'] = {'COMPONENT_AT_PI_SUPP', false, "CPistol Supperssor", false},
    },
    ['pumpshotgun'] = {
        ['gun'] = {'pumpshotgun', false, "Pump Shotgun"},
        ['COMPONENT_AT_AR_FLSH'] = {'COMPONENT_AT_AR_FLSH', false, "Pump Shotgun Flashlight", false},
        ['COMPONENT_AT_SR_SUPP'] = {'COMPONENT_AT_SR_SUPP', false, "Pump Shotgun Supperssor", false},
    },
    ['carbinerifle'] = {
        ['gun'] = {'carbinerifle', false, "Carbine Rifle"},
        ['COMPONENT_CARBINERIFLE_CLIP_01'] = {'COMPONENT_CARBINERIFLE_CLIP_01', true, "Carbine Default Magazine", true},
        ['COMPONENT_CARBINERIFLE_CLIP_02'] = {'COMPONENT_CARBINERIFLE_CLIP_02', false, "Carbine Extended Magazine", false},
        ['COMPONENT_CARBINERIFLE_CLIP_03'] = {'COMPONENT_CARBINERIFLE_CLIP_03', false, "Carbine Box Magazine", false},
        ['COMPONENT_AT_AR_FLSH'] = {'COMPONENT_AT_AR_FLSH', false, "Carbine Flashlight", false},
        ['COMPONENT_AT_SCOPE_MEDIUM'] = {'COMPONENT_AT_SCOPE_MEDIUM', false, "Carbine Scope", false},
        ['COMPONENT_AT_AR_SUPP'] = {'COMPONENT_AT_AR_SUPP', false, "Carbine Suppressor", false},
        ['COMPONENT_AT_AR_AFGRIP'] = {'COMPONENT_AT_AR_AFGRIP', false, "Carbine Grip", false},
    },
}