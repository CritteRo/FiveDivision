RegisterNetEvent('core.GiveAmmoToPlayer')
RegisterNetEvent('core.TogglePlayerWeaponMod')

RegisterCommand('gun', function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    GiveWeaponToPed(ped, "weapon_carbinerifle", 99, false, true)
    GiveWeaponComponentToPed(ped, "weapon_carbinerifle", 'COMPONENT_CARBINERIFLE_CLIP_02')
    GiveWeaponComponentToPed(ped, "weapon_carbinerifle", 'COMPONENT_AT_AR_FLSH')
    GiveWeaponComponentToPed(ped, "weapon_carbinerifle", 'COMPONENT_AT_SCOPE_MEDIUM')
    GiveWeaponComponentToPed(ped, "weapon_carbinerifle", 'COMPONENT_AT_AR_SUPP')
end)

AddEventHandler('core.GiveAmmoToPlayer', function(weapon)
    local src = source
    if PlayerInfo[src] ~= nil and PlayerInfo[src].weapons ~= nil then
        if PlayerInfo[src].weapons[weapon] ~= nil and PlayerInfo[src].weapons[weapon]['gun'][2] == true then
            local ped = GetPlayerPed(src)
            GiveWeaponToPed(ped, "weapon_"..PlayerInfo[src].weapons[weapon]['gun'][1], 30, false, true)
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