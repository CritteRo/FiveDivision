
comp11Index = 1
comp8Index = 1
comp7Index = 1
comp6Index = 1
comp5Index = 1
comp4Index = 1
comp1Index = 1
primaryHairIndex = 1
secondaryHairIndex = 1

coreMenuStyle = {titleColor = {255, 255, 255}, subTitleColor = {255, 255, 255}, titleBackgroundSprite = {dict = 'commonmenu', name = 'interaction_bgd'}}
RequestStreamedTextureDict('commonmenu', true)
WarMenu.CreateMenu('core.ClothesMenu', 'Cosmetics', "Variations Menu", coreMenuStyle)
AddEventHandler('core.ui.ShowClothesVariationsMenu', function()
    if WarMenu.IsAnyMenuOpened() then
        notify("Can't open another menu!")
        return
    end
    WarMenu.OpenMenu('core.ClothesMenu')

    primaryHairIndex = PlayerInfo.ped['hair'][5]+1
    secondaryHairIndex = PlayerInfo.ped['hair'][6]+1

    comp11Variations = {}
    comp8Variations = {}
    comp7Variations = {}
    comp6Variations = {}
    comp5Variations = {}
    comp4Variations = {}
    comp1Variations = {}
    hairColors = getAllColors()


    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 11, PlayerInfo.ped['comp11'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 11, PlayerInfo.ped['comp11'][1], i) then
            if i == PlayerInfo.ped['comp11'][2] then
                comp11Index = #comp11Variations + 1
            end
            comp11Variations[#comp11Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 8, PlayerInfo.ped['comp8'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 8, PlayerInfo.ped['comp8'][1], i) then
            if i == PlayerInfo.ped['comp8'][2] then
                comp8Index = #comp8Variations + 1
            end
            comp8Variations[#comp8Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 8, PlayerInfo.ped['comp7'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 8, PlayerInfo.ped['comp7'][1], i) then
            if i == PlayerInfo.ped['comp7'][2] then
                comp7Index = #comp7Variations + 1
            end
            comp7Variations[#comp7Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 6, PlayerInfo.ped['comp6'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 6, PlayerInfo.ped['comp6'][1], i) then
            if i == PlayerInfo.ped['comp6'][2] then
                comp6Index = #comp6Variations + 1
            end
            comp6Variations[#comp6Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 5, PlayerInfo.ped['comp5'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 5, PlayerInfo.ped['comp5'][1], i) then
            if i == PlayerInfo.ped['comp5'][2] then
                comp5Index = #comp5Variations + 1
            end
            comp5Variations[#comp5Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 4, PlayerInfo.ped['comp4'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 4, PlayerInfo.ped['comp4'][1], i) then
            if i == PlayerInfo.ped['comp4'][2] then
                comp4Index = #comp4Variations + 1
            end
            comp4Variations[#comp4Variations + 1] = i
        end
    end

    for i=0, GetNumberOfPedTextureVariations(PlayerPedId(), 1, PlayerInfo.ped['comp1'][1]), 1 do
        if IsPedComponentVariationValid(PlayerPedId(), 1, PlayerInfo.ped['comp1'][1], i) then
            if i == PlayerInfo.ped['comp1'][2] then
                comp1Index = #comp1Variations + 1
            end
            comp1Variations[#comp1Variations + 1] = i
        end
    end

    while true do
        if WarMenu.Begin('core.ClothesMenu') then
            --WarMenu.SetMenuTitle('core.ClothesMenu', tostring(stats.Name))
            --WarMenu.SetMenuSubTitle('core.ClothesMenu', string.format(locStats[stats.lang].subtitle, GetPlayerServerId(PlayerId()), tostring(stats.Name)))
            --WarMenu.SetMenuStyle('core.ClothesMenu', coreMenuStyle)
            
            local _, _primHairIndex = WarMenu.ComboBox('Primary Hair Color', hairColors, primaryHairIndex)
            if _primHairIndex ~= primaryHairIndex then
                primaryHairIndex = _primHairIndex
                setPlayerHairColor(primaryHairIndex-1, secondaryHairIndex-1)
            end
            local _, _secHairIndex = WarMenu.ComboBox('Secondary Hair Color', hairColors, secondaryHairIndex)
            if _secHairIndex ~= secondaryHairIndex then
                secondaryHairIndex = _secHairIndex
                setPlayerHairColor(primaryHairIndex-1, secondaryHairIndex-1)
            end

            local _, _comp1Index = WarMenu.ComboBox('Mask', comp1Variations, comp1Index)
            if _comp1Index ~= comp1Index then
                comp1Index = _comp1Index
                setPlayerSpecificComponent(1, PlayerInfo.ped['comp1'][1], comp1Variations[comp1Index])
            end

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

            local _, _comp7Index = WarMenu.ComboBox('Accessories', comp7Variations, comp7Index)
            if _comp7Index ~= comp7Index then
                comp7Index = _comp7Index
                setPlayerSpecificComponent(7, PlayerInfo.ped['comp7'][1], comp7Variations[comp7Index])
            end

            local _, _comp5Index = WarMenu.ComboBox('Bag', comp5Variations, comp5Index)
            if _comp5Index ~= comp5Index then
                comp5Index = _comp5Index
                setPlayerSpecificComponent(5, PlayerInfo.ped['comp5'][1], comp5Variations[comp5Index])
            end

            local _, _comp4Index = WarMenu.ComboBox('Pants', comp4Variations, comp4Index)
            if _comp4Index ~= comp4Index then
                comp4Index = _comp4Index
                setPlayerSpecificComponent(4, PlayerInfo.ped['comp4'][1], comp4Variations[comp4Index])
            end

            local _, _comp6Index = WarMenu.ComboBox('Shoes', comp6Variations, comp6Index)
            if _comp6Index ~= comp6Index then
                comp6Index = _comp6Index
                setPlayerSpecificComponent(6, PlayerInfo.ped['comp6'][1], comp6Variations[comp6Index])
            end

            if WarMenu.IsMenuAboutToBeClosed() then
                TriggerServerEvent('core.UpdatePlayerClothesVariations', comp11Variations[comp11Index], comp8Variations[comp8Index], comp7Variations[comp7Index], comp6Variations[comp6Index], comp5Variations[comp5Index], comp4Variations[comp4Index], comp1Variations[comp1Index], primaryHairIndex-1, secondaryHairIndex-1)
            end

            WarMenu.End()
        else
            return
        end
        Citizen.Wait(0)
    end
end)

WarMenu.CreateMenu('core.ClothesMenu2', 'Cosmetics', "Wardrobe Menu", coreMenuStyle)
WarMenu.CreateSubMenu('core.ClothesMenu2_masks', 'core.ClothesMenu2', "Wardrobe Masks", coreMenuStyle)
WarMenu.CreateSubMenu('core.ClothesMenu2_tops', 'core.ClothesMenu2', "Wardrobe Tops", coreMenuStyle)
WarMenu.CreateSubMenu('core.ClothesMenu2_accessories', 'core.ClothesMenu2', "Wardrobe Accessories", coreMenuStyle)
WarMenu.CreateSubMenu('core.ClothesMenu2_bags', 'core.ClothesMenu2', "Wardrobe Bags", coreMenuStyle)
WarMenu.CreateSubMenu('core.ClothesMenu2_pants', 'core.ClothesMenu2', "Wardrobe Pants", coreMenuStyle)
WarMenu.CreateSubMenu('core.ClothesMenu2_shoes', 'core.ClothesMenu2', "Wardrobe Shoes", coreMenuStyle)
WarMenu.CreateSubMenu('core.ClothesMenu2_hair', 'core.ClothesMenu2', "Wardrobe Hair Styles", coreMenuStyle)
AddEventHandler('core.ui.ShowWardrobeMenu', function()
    if WarMenu.IsAnyMenuOpened() then
        notify("Can't open another menu!")
        return
    end
    WarMenu.OpenMenu('core.ClothesMenu2')

    while true do
        if WarMenu.Begin('core.ClothesMenu2') then
            WarMenu.MenuButton("Hair Styles", 'core.ClothesMenu2_hair')
            WarMenu.MenuButton("Masks", 'core.ClothesMenu2_masks')
            WarMenu.MenuButton("Tops", 'core.ClothesMenu2_tops')
            WarMenu.MenuButton("Accessories", 'core.ClothesMenu2_accessories')
            WarMenu.MenuButton("Bags", 'core.ClothesMenu2_bags')
            WarMenu.MenuButton("Pants", 'core.ClothesMenu2_pants')
            WarMenu.MenuButton("Shoes", 'core.ClothesMenu2_shoes')
            WarMenu.End()
        elseif WarMenu.Begin('core.ClothesMenu2_tops') then ---tops
            for i,k in pairs(PlayerInfo.clothes) do
                if cosmeticClothes[k][PlayerInfo.ped['model']][1][1] == "comp3" then
                    WarMenu.Button(tostring(cosmeticClothes[k][PlayerInfo.ped['model']][1][3]))
                    if WarMenu.IsItemSelected() then
                        TriggerServerEvent('core.SetPlayerCosmeticItem', k)
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.ClothesMenu2_shoes') then --shoes
            for i,k in pairs(PlayerInfo.clothes) do
                if cosmeticClothes[k][PlayerInfo.ped['model']][1][1] == "comp6" then
                    WarMenu.Button(tostring(cosmeticClothes[k][PlayerInfo.ped['model']][1][3]))
                    if WarMenu.IsItemSelected() then
                        TriggerServerEvent('core.SetPlayerCosmeticItem', k)
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.ClothesMenu2_pants') then --pants
            for i,k in pairs(PlayerInfo.clothes) do
                if cosmeticClothes[k][PlayerInfo.ped['model']][1][1] == "comp4" then
                    WarMenu.Button(tostring(cosmeticClothes[k][PlayerInfo.ped['model']][1][3]))
                    if WarMenu.IsItemSelected() then
                        TriggerServerEvent('core.SetPlayerCosmeticItem', k)
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.ClothesMenu2_hair') then --hair
            for i,k in pairs(PlayerInfo.clothes) do
                if cosmeticClothes[k][PlayerInfo.ped['model']][1][1] == "comp2" then
                    WarMenu.Button(tostring(cosmeticClothes[k][PlayerInfo.ped['model']][1][3]))
                    if WarMenu.IsItemSelected() then
                        TriggerServerEvent('core.SetPlayerCosmeticItem', k)
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.ClothesMenu2_accessories') then --accessories
            for i,k in pairs(PlayerInfo.clothes) do
                if cosmeticClothes[k][PlayerInfo.ped['model']][1][1] == "comp7" then
                    WarMenu.Button(tostring(cosmeticClothes[k][PlayerInfo.ped['model']][1][3]))
                    if WarMenu.IsItemSelected() then
                        TriggerServerEvent('core.SetPlayerCosmeticItem', k)
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.ClothesMenu2_masks') then --accessories
            for i,k in pairs(PlayerInfo.clothes) do
                if cosmeticClothes[k][PlayerInfo.ped['model']][1][1] == "comp1" then
                    WarMenu.Button(tostring(cosmeticClothes[k][PlayerInfo.ped['model']][1][3]))
                    if WarMenu.IsItemSelected() then
                        TriggerServerEvent('core.SetPlayerCosmeticItem', k)
                    end
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.ClothesMenu2_bags') then --accessories
            for i,k in pairs(PlayerInfo.clothes) do
                if cosmeticClothes[k][PlayerInfo.ped['model']][1][1] == "comp5" then
                    WarMenu.Button(tostring(cosmeticClothes[k][PlayerInfo.ped['model']][1][3]))
                    if WarMenu.IsItemSelected() then
                        TriggerServerEvent('core.SetPlayerCosmeticItem', k)
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


RegisterCommand('variations', function()
    TriggerEvent('core.ui.ShowClothesVariationsMenu')
end)

RegisterCommand('wardrobe', function()
    TriggerEvent('core.ui.ShowWardrobeMenu')
end)

function getAllColors()
    local table = {}
    for i=0, 63, 1 do
        table[i+1] = i
    end
    return table
end