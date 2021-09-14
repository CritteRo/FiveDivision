weaponMenu = ""

WarMenu.CreateMenu('core.WeaponsMenu', 'Weapon Mods', "Weapon Mods Menu", coreMenuStyle)
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
                        WarMenu.OpenMenu('core.WeaponsMenu1')
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.WeaponsMenu1')
        else
            return
        end
        Citizen.Wait(0)
    end
end)

RegisterCommand('weapons', function()
    TriggerEvent('core.ui.ShowWeaponsVariationsMenu')
end)