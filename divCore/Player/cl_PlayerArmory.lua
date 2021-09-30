RegisterNetEvent('core.SetWeaponTints')

weaponMenu = ""
local _altSprite = false
coreMenuStyle = {titleColor = {255, 255, 255}, subTitleColor = {255, 255, 255}, titleBackgroundSprite = {dict = 'commonmenu', name = 'interaction_bgd'}}
WarMenu.CreateMenu('core.WeaponsMenu', 'Weapon Mods', "Weapon Mods Menu", coreMenuStyle)
WarMenu.CreateSubMenu('core.WeaponsMenu_variations', 'core.WeaponsMenu', "Weapon Mods Toggle Menu", coreMenuStyle)
AddEventHandler('core.ui.ShowWeaponsVariationsMenu', function()
    if WarMenu.IsAnyMenuOpened() then
        notify("Can't open another menu!")
        return
    end
    WarMenu.OpenMenu('core.WeaponsMenu')

    local wTint = {}
    local tintIndex = 1

    while true do
        if WarMenu.Begin('core.WeaponsMenu') then
            for i,k in pairs(PlayerInfo.weapons) do
                if k['gun'][2] == true then
                    WarMenu.Button(k['gun'][3])
                    if WarMenu.IsItemSelected() then
                        weaponMenu = k['gun'][1]
                        wTint = {}
                        for i=0, GetWeaponTintCount(GetHashKey("weapon_"..weaponMenu)), 1 do
                            if GetPedWeaponTintIndex(PlayerPedId(), GetHashKey("weapon_"..weaponMenu)) == i then
                                tintIndex = i+1
                            end
                            wTint[i+1] = i
                        end
                        WarMenu.OpenMenu('core.WeaponsMenu_variations')
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.WeaponsMenu_variations') then
            if PlayerInfo.weapons[weaponMenu] ~= nil then
                WarMenu.SpriteButton('Replenish Ammo', 'commonmenu', _altSprite and 'shop_ammo_icon_b' or 'shop_ammo_icon_a') --replenish ammo
                if WarMenu.IsItemHovered() then
                    _altSprite = true
                else
                    _altSprite = false
                end
                if WarMenu.IsItemSelected() then
                    TriggerServerEvent('core.GiveAmmoToPlayer', weaponMenu)
                end
                local _, _Index = WarMenu.ComboBox('Weapon Tint', wTint, tintIndex)
                if _Index ~= tintIndex then
                    tintIndex = _Index
                    SetPedWeaponTintIndex(PlayerPedId(), GetHashKey("weapon_"..weaponMenu), tintIndex -1)
                    TriggerServerEvent('core.TogglePlayerWeaponMod', weaponMenu, "tint", tintIndex -1)
                end
                WarMenu.CheckBox("Give Weapon on respawn", PlayerInfo.weapons[weaponMenu]['onRespawn'][2]) --checkbox. Respawn with this gun.
                if WarMenu.IsItemSelected() then
                    TriggerServerEvent('core.TogglePlayerWeaponMod', weaponMenu, "onRespawn")
                end
                for i,k in pairs(PlayerInfo.weapons[weaponMenu]) do
                    if k[1] ~= weaponMenu and k[1] ~= "onRespawn" and k[2] == true then
                        WarMenu.CheckBox(k[3], k[4])
                        if WarMenu.IsItemSelected() then
                            TriggerServerEvent('core.TogglePlayerWeaponMod', weaponMenu, k[1])
                        end
                    end
                end
            end
            WarMenu.End()
        else
            return
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler('core.SetWeaponTints', function()
    local ped = PlayerPedId()
    for i,k in pairs(PlayerInfo.weapons) do
        if k['gun'][2] == true then
            SetPedWeaponTintIndex(ped, GetHashKey("weapon_"..k['gun'][1]), k['gun'][4])
        end
    end
end)

RegisterCommand('weapons', function()
    TriggerEvent('core.ui.ShowWeaponsVariationsMenu')
end)