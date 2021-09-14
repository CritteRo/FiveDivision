RegisterCommand('gun', function(source, args)
    local src = source
    local ped = GetPlayerPed(src)
    GiveWeaponToPed(ped, "weapon_carbinerifle", 99, false, true)
    GiveWeaponComponentToPed(ped, "weapon_carbinerifle", 'COMPONENT_CARBINERIFLE_CLIP_02')
    GiveWeaponComponentToPed(ped, "weapon_carbinerifle", 'COMPONENT_AT_AR_FLSH')
    GiveWeaponComponentToPed(ped, "weapon_carbinerifle", 'COMPONENT_AT_SCOPE_MEDIUM')
    GiveWeaponComponentToPed(ped, "weapon_carbinerifle", 'COMPONENT_AT_AR_SUPP')
end)
