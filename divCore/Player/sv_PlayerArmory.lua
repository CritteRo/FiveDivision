RegisterNetEvent('core.GiveAmmoToPlayer')
RegisterNetEvent('core.TogglePlayerWeaponMod')
RegisterNetEvent('core.RequestSpawnLoadout')
RegisterNetEvent('core.SavePlayerLoadout')

RegisterCommand('chute', function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    GiveWeaponToPed(ped, "gadget_parachute", 1, false, false)
end)

local _ammo = 999

AddEventHandler('core.GiveAmmoToPlayer', function(weapon)
    local src = source
    if PlayerInfo[src] ~= nil and PlayerInfo[src].weapons ~= nil then
        if PlayerInfo[src].weapons[weapon] ~= nil and PlayerInfo[src].weapons[weapon]['gun'][2] == true then
            local ped = GetPlayerPed(src)
            GiveWeaponToPed(ped, "weapon_"..PlayerInfo[src].weapons[weapon]['gun'][1], _ammo, false, true)
            for i,k in pairs(PlayerInfo[src].weapons[weapon]) do
                if k[1] ~= weapon and k[2] == true and k[4] == true then
                    GiveWeaponComponentToPed(ped, "weapon_"..PlayerInfo[src].weapons[weapon]['gun'][1], k[1])
                end
            end
        end
    end
end)

AddEventHandler('core.TogglePlayerWeaponMod', function(weapon, weaponmod, modIndex)
    local src = source
    if PlayerInfo[src] ~= nil and PlayerInfo[src].weapons ~= nil then
        if PlayerInfo[src].weapons[weapon] ~= nil and PlayerInfo[src].weapons[weapon]['gun'][2] == true then
            if weaponmod == "onRespawn" then
                PlayerInfo[src].weapons[weapon][weaponmod][2] = not PlayerInfo[src].weapons[weapon][weaponmod][2]
                TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src], false)
            elseif weaponmod == 'tint' and tonumber(modIndex) ~= nil then
                PlayerInfo[src].weapons[weapon]['gun'][4] = tonumber(modIndex)
                TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src], true)
            elseif PlayerInfo[src].weapons[weapon][weaponmod] ~= nil and PlayerInfo[src].weapons[weapon][weaponmod][2] == true then
                local ped = GetPlayerPed(src)
                PlayerInfo[src].weapons[weapon][weaponmod][4] = not PlayerInfo[src].weapons[weapon][weaponmod][4]
                if PlayerInfo[src].weapons[weapon][weaponmod][4] == false then
                    RemoveWeaponComponentFromPed(ped, "weapon_"..PlayerInfo[src].weapons[weapon]['gun'][1], weaponmod)
                elseif PlayerInfo[src].weapons[weapon][weaponmod][4] == true then
                    GiveWeaponComponentToPed(ped, "weapon_"..PlayerInfo[src].weapons[weapon]['gun'][1], weaponmod)
                end
                TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src], false)
            end
        end
    end
end)

AddEventHandler('core.SavePlayerLoadout', function()
    local src = source
    updateWeaponsInDatabase(src, PlayerInfo[src].uid)
end)

AddEventHandler('core.RequestSpawnLoadout', function()
    local src = source
    local ped = GetPlayerPed(src)
    if PlayerInfo[src] ~= nil and PlayerInfo[src].weapons ~= nil then
        for i,k in pairs(PlayerInfo[src].weapons) do
            if k['gun'][2] == true and k['onRespawn'][2] == true then
                local gun = k['gun'][1]
                GiveWeaponToPed(ped, "weapon_"..gun, _ammo, false, true)
                for v,h in pairs(k) do
                    if h[1] ~= gun and h[1] ~= 'onRespawn' then
                        if h[2] == true and h[4] == true then
                            GiveWeaponComponentToPed(ped, "weapon_"..gun, h[1])
                        end
                    end
                end
            end
        end
        TriggerClientEvent('core.SetWeaponTints', src)
    end
end)