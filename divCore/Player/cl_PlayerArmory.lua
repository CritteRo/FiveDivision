weaponMenu = ""

WarMenu.CreateMenu('core.WeaponsMenu', 'Weapon Mods', "Weapon Mods Menu")
WarMenu.CreateSubMenu('core.WeaponsMenu_variations', 'core.WeaponsMenu', "Weapon Mods Toggle Menu")
AddEventHandler('core.ui.ShowWeaponsVariationsMenu', function()
    if WarMenu.IsAnyMenuOpened() then
        notify("Can't open another menu!")
        return
    end
    WarMenu.OpenMenu('core.WeaponsMenu')
    while true do
        if WarMenu.Begin('core.WeaponsMenu') then
            for i,k in pairs(PlayerInfo.weapons) do
                if k['gun'][2] == true then
                    WarMenu.Button(k['gun'][3])
                    if WarMenu.IsItemSelected() then
                        weaponMenu = k['gun'][1]
                        WarMenu.OpenMenu('core.WeaponsMenu_variations')
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.WeaponsMenu_variations') then
            if PlayerInfo.weapons[weaponMenu] ~= nil then
                WarMenu.Button('Get Ammo')
                if WarMenu.IsItemSelected() then
                    TriggerServerEvent('core.GiveAmmoToPlayer', weaponMenu)
                end
                for i,k in pairs(PlayerInfo.weapons[weaponMenu]) do
                    if k[1] ~= weaponMenu and k[2] == true then
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

RegisterCommand('weapons', function()
    TriggerEvent('core.ui.ShowWeaponsVariationsMenu')
end)