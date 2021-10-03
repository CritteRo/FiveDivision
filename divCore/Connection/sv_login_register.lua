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
                                                waitingForLevel = false,
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

RegisterCommand('_reload_me', function(source, args)
    local src = source
    local name = GetPlayerName(src)
    local identifiers = GetPlayerIdentifiers(src)
    local license  = false

    for k,v in pairs(GetPlayerIdentifiers(src))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
        
    end
    exports.oxmysql:fetch("SELECT COUNT(uid) AS idcount FROM users WHERE `name` = ?", {name}, function(result) --numara conturile cu numele asta
        if result[1]['idcount'] == 1 then --daca exista license => exista un cont cu numele ala
            local send = 1
            exports.oxmysql:fetch("SELECT * FROM `users` WHERE `name` = ?",{name},function (result)
                if result[1].license == license then
                    if result[1].bantime == 0 then
                        print(string.format("Reloaded with %s", tostring(license)))
                        PlayerInfo[src] = {
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
                        if inCall[src] ~= nil then
                        else
                            inCall[src] = { --making sure we have the goddamn array set.
                            name = GetPlayerName(src),
                            status = 0,
                            sleepMode = 0,
                            lang = "en",
                        }
                        TriggerEvent('phone.sv.GatherContacts')
                        end
                        TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src])
                        TriggerEvent('core.UpdateServerResources', src, PlayerInfo[src])
                    end
                end
            end)
        end
    end)
end)

AddEventHandler('playerJoining', function(oldID)
    local src = source
    PlayerInfo[src] = tempData[tonumber(oldID)]
    TriggerClientEvent('core.GetInitialStats', src, PlayerInfo[src])
    TriggerEvent('core.UpdateServerResources', src, PlayerInfo[src])
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
    ['charToken'] = 1,
}

defaultChar = {
    ['model'] = 'mp_m_freemode_01',
    ['blend'] = {21,0,1.0,1.0}, --motherID, fatherID, shapeMix, skinMix,
    ['hair'] = {1, 255, 1, 255, 0, 0}, --head hair, facial hair, eyebrows, chest hair, hair primary color, hair secondary color.
    ['overlay'] = {255, 255, 255, 0, 255, 0, 255, 255, 255, 0, 255}, --blemishes, ageing, makeup, makeupColor, blush, blushColor, complexion, sun damage, lipstick, lipstickColor, moles
    ['overlayColor'] = {0,0,0,0,0,0}, --makeupPrimary, makeupSecondary, blushPrimary, blushSecondary, lipstickPrimary, lipstickSecondary
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
    ['comp11'] = {115,0},
    ['prop0'] = {-1,0}, -- -1 = no prop
    ['prop1'] = {-1,0},
    ['prop2'] = {-1,0},
    ['prop6'] = {-1,0},
    ['prop7'] = {-1,0},
}

defaultClothes = {1,2,3,4,5,6,7} --Contains default cosmetics ids.

defaultWeapons = {
    ['pistol'] = {
        ['gun'] = {'pistol', false, "Pistol", 0},
        ['onRespawn'] = {'onRespawn', false},
        ['COMPONENT_PISTOL_CLIP_02'] = {'COMPONENT_PISTOL_CLIP_02', false, "Pistol Extended Clip", false},
        ['COMPONENT_AT_PI_FLSH'] = {'COMPONENT_AT_PI_FLSH', false, "Pistol Flashlight", false},
        ['COMPONENT_AT_PI_SUPP_02'] = {'COMPONENT_AT_PI_SUPP_02', false, "Pistol Suppressor", false},
    },
    ['combatpistol'] = {
        ['gun'] = {'combatpistol', false, "Combat Pistol", 0},
        ['onRespawn'] = {'onRespawn', false},
        ['COMPONENT_COMBATPISTOL_CLIP_02'] = {'COMPONENT_COMBATPISTOL_CLIP_02', false, "CPistol Extended Clip", false},
        ['COMPONENT_AT_PI_FLSH'] = {'COMPONENT_AT_PI_FLSH', false, "CPistol Flashlight", false},
        ['COMPONENT_AT_PI_SUPP'] = {'COMPONENT_AT_PI_SUPP', false, "CPistol Supperssor", false},
    },
    ['microsmg'] = {
        ['gun'] = {'microsmg', false, "Micro SMG", 0},
        ['onRespawn'] = {'onRespawn', false},
        ['COMPONENT_MICROSMG_CLIP_02'] = {'COMPONENT_MICROSMG_CLIP_02', false, "MicroSMG Extended Clip", false},
        ['COMPONENT_AT_PI_FLSH'] = {'COMPONENT_AT_PI_FLSH', false, "MicroSMG Flashlight", false},
        ['COMPONENT_AT_SCOPE_MACRO'] = {'COMPONENT_AT_SCOPE_MACRO', false, "MicroSMG Scope", false},
        ['COMPONENT_AT_AR_SUPP_02'] = {'COMPONENT_AT_AR_SUPP_02', false, "MicroSMG Suppressor", false},
    },
    ['smg_mk2'] = {
        ['gun'] = {'smg_mk2', false, "SMG Mk2", 0},
        ['onRespawn'] = {'onRespawn', false},
        ['COMPONENT_SMG_MK2_CLIP_02'] = {'COMPONENT_SMG_MK2_CLIP_02', false, "SMG Extended Clip", false},
        ['COMPONENT_AT_AR_FLSH'] = {'COMPONENT_AT_AR_FLSH', false, "SMG Flashlight", false},
        ['COMPONENT_AT_SIGHTS_SMG'] = {'COMPONENT_AT_SIGHTS_SMG', false, "SMG Holo Sight", false},
        ['COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2'] = {'COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2', false, "SMG Small Scope", false},
        ['COMPONENT_AT_SCOPE_SMALL_SMG_MK2'] = {'COMPONENT_AT_SCOPE_SMALL_SMG_MK2', false, "SMG Medium Scope", false},
        ['COMPONENT_AT_PI_SUPP'] = {'COMPONENT_AT_PI_SUPP', false, "SMG Suppressor", false},
        ['COMPONENT_AT_MUZZLE_01'] = {'COMPONENT_AT_MUZZLE_01', false, "SMG Flat Muzzle Brake", false},
        ['COMPONENT_AT_MUZZLE_02'] = {'COMPONENT_AT_MUZZLE_02', false, "SMG Tactical Muzzle Brake", false},
        ['COMPONENT_AT_MUZZLE_03'] = {'COMPONENT_AT_MUZZLE_03', false, "SMG Fat-End Muzzle Brake", false},
        ['COMPONENT_AT_SB_BARREL_02'] = {'COMPONENT_AT_SB_BARREL_02', false, "SMG Heavy Barrel", false},
        ['COMPONENT_SMG_MK2_CAMO'] = {'COMPONENT_SMG_MK2_CAMO', false, "SMG Digital Camo", false},
        ['COMPONENT_SMG_MK2_CAMO_04'] = {'COMPONENT_SMG_MK2_CAMO_04', false, "SMG Skull Camo", false},
        ['COMPONENT_SMG_MK2_CAMO_06'] = {'COMPONENT_SMG_MK2_CAMO_06', false, "SMG Perseus Camo", false},
        ['COMPONENT_SMG_MK2_CAMO_10'] = {'COMPONENT_SMG_MK2_CAMO_10', false, "SMG Boom! Camo", false},
        ['COMPONENT_SMG_MK2_CAMO_IND_01'] = {'COMPONENT_SMG_MK2_CAMO_IND_01', false, "SMG Patriotic Camo", false},
    },
    ['pumpshotgun'] = {
        ['gun'] = {'pumpshotgun', false, "Pump Shotgun", 0},
        ['onRespawn'] = {'onRespawn', false},
        ['COMPONENT_AT_AR_FLSH'] = {'COMPONENT_AT_AR_FLSH', false, "Pump Shotgun Flashlight", false},
        ['COMPONENT_AT_SR_SUPP'] = {'COMPONENT_AT_SR_SUPP', false, "Pump Shotgun Supperssor", false},
    },
    ['carbinerifle'] = {
        ['gun'] = {'carbinerifle', false, "Carbine Rifle", 0},
        ['onRespawn'] = {'onRespawn', false},
        ['COMPONENT_CARBINERIFLE_CLIP_02'] = {'COMPONENT_CARBINERIFLE_CLIP_02', false, "Carbine Extended Magazine", false},
        ['COMPONENT_CARBINERIFLE_CLIP_03'] = {'COMPONENT_CARBINERIFLE_CLIP_03', false, "Carbine Box Magazine", false},
        ['COMPONENT_AT_AR_FLSH'] = {'COMPONENT_AT_AR_FLSH', false, "Carbine Flashlight", false},
        ['COMPONENT_AT_SCOPE_MEDIUM'] = {'COMPONENT_AT_SCOPE_MEDIUM', false, "Carbine Scope", false},
        ['COMPONENT_AT_AR_SUPP'] = {'COMPONENT_AT_AR_SUPP', false, "Carbine Suppressor", false},
        ['COMPONENT_AT_AR_AFGRIP'] = {'COMPONENT_AT_AR_AFGRIP', false, "Carbine Grip", false},
    },
    ['carbinerifle_mk2'] = {
        ['gun'] = {'carbinerifle_mk2', false, "Carbine Rifle Mk2", 0},
        ['onRespawn'] = {'onRespawn', false},
        ['COMPONENT_CARBINERIFLE_MK2_CLIP_02'] = {'COMPONENT_CARBINERIFLE_MK2_CLIP_02', false, "Carbine Mk2 Extended Magazine", false},
        ['COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY'] = {'COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY', false, "Carbine Mk2 Incendiary Rounds", false},
        ['COMPONENT_AT_AR_FLSH'] = {'COMPONENT_AT_AR_FLSH', false, "Carbine Mk2 Flashlight", false},
        ['COMPONENT_AT_SIGHTS'] = {'COMPONENT_AT_SIGHTS', false, "Carbine Mk2 Holo Sight", false},
        ['COMPONENT_AT_SCOPE_MACRO_MK2'] = {'COMPONENT_AT_SCOPE_MACRO_MK2', false, "Carbine Mk2 Small Scope", false},
        ['COMPONENT_AT_SCOPE_MEDIUM_MK2'] = {'COMPONENT_AT_SCOPE_MEDIUM_MK2', false, "Carbine Mk2 Large Scope", false},
        ['COMPONENT_AT_AR_SUPP'] = {'COMPONENT_AT_AR_SUPP', false, "Carbine Mk2 Suppressor", false},
        ['COMPONENT_AT_AR_AFGRIP_02'] = {'COMPONENT_AT_AR_AFGRIP_02', false, "Carbine Mk2 Grip", false},
        ['COMPONENT_AT_MUZZLE_01'] = {'COMPONENT_AT_MUZZLE_01', false, "Carbine Mk2 Flat Muzzle Brake", false},
        ['COMPONENT_AT_MUZZLE_02'] = {'COMPONENT_AT_MUZZLE_02', false, "Carbine Mk2 Tactical Muzzle Brake", false},
        ['COMPONENT_AT_MUZZLE_03'] = {'COMPONENT_AT_MUZZLE_03', false, "Carbine Mk2 Fat-End Muzzle Brake", false},
        ['COMPONENT_AT_MUZZLE_04'] = {'COMPONENT_AT_MUZZLE_04', false, "Carbine Mk2 Precision Muzzle Brake", false},
        ['COMPONENT_AT_CR_BARREL_02'] = {'COMPONENT_AT_CR_BARREL_02', false, "Carbine Mk2 Heavy Barrel", false},
        ['COMPONENT_CARBINERIFLE_MK2_CAMO'] = {'COMPONENT_CARBINERIFLE_MK2_CAMO', false, "Carbine Mk2 Digital Camo", false},
        ['COMPONENT_CARBINERIFLE_MK2_CAMO_02'] = {'COMPONENT_CARBINERIFLE_MK2_CAMO_02', false, "Carbine Mk2 Brushstroke Camo", false},
        ['COMPONENT_CARBINERIFLE_MK2_CAMO_03'] = {'COMPONENT_CARBINERIFLE_MK2_CAMO_03', false, "Carbine Mk2 Woodland Camo", false},
        ['COMPONENT_CARBINERIFLE_MK2_CAMO_04'] = {'COMPONENT_CARBINERIFLE_MK2_CAMO_04', false, "Carbine Mk2 Skull Camo", false},
        ['COMPONENT_CARBINERIFLE_MK2_CAMO_06'] = {'COMPONENT_CARBINERIFLE_MK2_CAMO_06', false, "Carbine Mk2 Perseus Camo", false},
        ['COMPONENT_CARBINERIFLE_MK2_CAMO_08'] = {'COMPONENT_CARBINERIFLE_MK2_CAMO_08', false, "Carbine Mk2 Zebra Camo", false},
        ['COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01'] = {'COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01', false, "Carbine Mk2 Patriotic Camo", false},
    },
}