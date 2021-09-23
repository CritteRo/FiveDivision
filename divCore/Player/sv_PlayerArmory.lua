RegisterNetEvent('core.GiveAmmoToPlayer')
RegisterNetEvent('core.TogglePlayerWeaponMod')

RegisterCommand('chute', function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    GiveWeaponToPed(ped, "gadget_parachute", 1, false, false)
end)

AddEventHandler('core.GiveAmmoToPlayer', function(weapon)
    local src = source
    local _ammo = 999
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

AddEventHandler('core.TogglePlayerWeaponMod', function(weapon, weaponmod)
    local src = source
    if PlayerInfo[src] ~= nil and PlayerInfo[src].weapons ~= nil then
        if PlayerInfo[src].weapons[weapon] ~= nil and PlayerInfo[src].weapons[weapon]['gun'][2] == true then
            if PlayerInfo[src].weapons[weapon][weaponmod] ~= nil and PlayerInfo[src].weapons[weapon][weaponmod][2] == true then
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