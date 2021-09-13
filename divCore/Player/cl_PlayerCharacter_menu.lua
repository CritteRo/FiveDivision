coreMenuStyle = {titleColor = {255, 255, 255}, subTitleColor = {255, 255, 255}, titleBackgroundSprite = {dict = 'commonmenu', name = 'interaction_bgd'}}
comp11Index = 1
comp8Index = 1
comp4Index = 1
comp6Index = 1

WarMenu.CreateMenu('core.ClothesMenu', 'Cosmetics', "Cosmetics Menu")
AddEventHandler('core.ui.ShowClothesMenu', function()
    if WarMenu.IsAnyMenuOpened() then
        notify("Can't open another menu!")
        return
    end
    WarMenu.OpenMenu('core.ClothesMenu')

    comp11Variations = {}
    comp8Variations = {}
    comp4Variations = {}
    comp6Variations = {}

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 11, PlayerInfo.ped['comp11'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 11, PlayerInfo.ped['comp11'][1], i) then
            comp11Variations[#comp11Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 8, PlayerInfo.ped['comp8'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 8, PlayerInfo.ped['comp8'][1], i) then
            comp8Variations[#comp8Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 6, PlayerInfo.ped['comp6'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 6, PlayerInfo.ped['comp6'][1], i) then
            comp6Variations[#comp6Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 4, PlayerInfo.ped['comp4'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 4, PlayerInfo.ped['comp4'][1], i) then
            comp4Variations[#comp4Variations + 1] = i
        end
    end

    while true do
        if WarMenu.Begin('core.ClothesMenu') then
            --WarMenu.SetMenuTitle('core.ClothesMenu', tostring(stats.Name))
            --WarMenu.SetMenuSubTitle('core.ClothesMenu', string.format(locStats[stats.lang].subtitle, GetPlayerServerId(PlayerId()), tostring(stats.Name)))
            WarMenu.SetMenuStyle('core.ClothesMenu', coreMenuStyle)
            
            local _, _comp11Index = WarMenu.ComboBox('Shirt', comp11Variations, comp11Index)
            if _comp11Index ~= comp11Index then
                comp11Index = _comp11Index
                setPlayerSpecificComponent(11, PlayerInfo.ped['comp11'][1], comp11Variations[comp11Index])
            end

            local _, _comp8Index = WarMenu.ComboBox('Undershirt', comp8Variations, comp8Index)
            if _comp8Index ~= comp8Index then
                comp8Index = _comp8Index
                setPlayerSpecificComponent(8, PlayerInfo.ped['comp8'][1], comp8Variations[comp8Index])
            end

            local _, _comp6Index = WarMenu.ComboBox('Shoes', comp6Variations, comp6Index)
            if _comp6Index ~= comp6Index then
                comp6Index = _comp6Index
                setPlayerSpecificComponent(6, PlayerInfo.ped['comp6'][1], comp6Variations[comp6Index])
            end

            local _, _comp4Index = WarMenu.ComboBox('Pant', comp4Variations, comp4Index)
            if _comp4Index ~= comp4Index then
                comp4Index = _comp4Index
                setPlayerSpecificComponent(4, PlayerInfo.ped['comp4'][1], comp4Variations[comp4Index])
            end

            if WarMenu.IsMenuAboutToBeClosed() then
                TriggerServerEvent('core.UpdatePlayerClothesVariations', comp11Variations[comp11Index], comp8Variations[comp8Index], comp6Variations[comp6Index], comp4Variations[comp4Index])
            end

            WarMenu.End()
        else
            return
        end
        Citizen.Wait(0)
    end
end)

RegisterCommand('variations', function()
    TriggerEvent('core.ui.ShowClothesMenu')
end)