function setPlayerCharacter(character)
    RequestModel(character['model'])
    while not HasModelLoaded(character['model']) do
        RequestModel(character['model'])
        Wait(0)
    end
    SetPlayerModel(PlayerId(), character['model'])
    SetModelAsNoLongerNeeded(character['model'])

    SetPedHeadBlendData(PlayerPedId(), character['blend'][1], character['blend'][2], 0, character['blend'][1], character['blend'][2], 0, character['blend'][3], character['blend'][4], 0.0, false)
    setPlayerClothes(character)
end

function setPlayerClothes(character)
    local ped = PlayerPedId()
    -- ['overlay'] = {255, 255, 255, 0, 255, 0, 255, 255, 255, 0, 255}, --blemishes, ageing, makeup, makeupColor, blush, blushColor, complexion, sun damage, lipstick, lipstickColor, freckles
    SetPedHelmet(ped, false)
    SetPedHeadOverlay(ped, 0, character['overlay'][1], 1.0) --blemishes
    SetPedHeadOverlay(ped, 1, character['hair'][2], 1.0) --facHair
    SetPedHeadOverlay(ped, 2, character['hair'][3], 1.0) --eyeHair
    SetPedHeadOverlay(ped, 3, character['overlay'][2], 1.0) --age
    SetPedHeadOverlay(ped, 4, character['overlay'][3], 1.0) --makeup
    SetPedHeadOverlay(ped, 5, character['overlay'][5], 1.0) --blush
    SetPedHeadOverlay(ped, 6, character['overlay'][7], 1.0) --complexion
    SetPedHeadOverlay(ped, 7, character['overlay'][8], 1.0) --sun damage
    SetPedHeadOverlay(ped, 8, character['overlay'][9], 1.0) --lipstick
    SetPedHeadOverlay(ped, 9, character['overlay'][11], 1.0) --freckles
    SetPedHeadOverlay(ped, 10, character['hair'][4], 1.0) --chestHair
    SetPedHeadOverlayColor(ped, 1, 1, character['hair'][5], character['hair'][5])
    SetPedHeadOverlayColor(ped, 2, 1, character['hair'][5], character['hair'][5])
    SetPedHeadOverlayColor(ped, 4, 1, character['overlay'][4], character['overlay'][4])
    SetPedHeadOverlayColor(ped, 5, 1, character['overlay'][6], character['overlay'][6])
    SetPedHeadOverlayColor(ped, 8, 1, character['overlay'][10], character['overlay'][10])
    SetPedHeadOverlayColor(ped, 10, 1, character['hair'][5], character['hair'][5])
    SetPedHairColor(ped, character['hair'][5], character['hair'][5])
    SetPedComponentVariation(ped, 1, character['comp1'][1], character['comp1'][2], 1)
    SetPedComponentVariation(ped, 2, character['comp2'][1], character['comp2'][2], 1)
    SetPedComponentVariation(ped, 3, character['comp3'][1], character['comp3'][2], 1)
    SetPedComponentVariation(ped, 4, character['comp4'][1], character['comp4'][2], 1)
    SetPedComponentVariation(ped, 5, character['comp5'][1], character['comp5'][2], 1)
    SetPedComponentVariation(ped, 6, character['comp6'][1], character['comp6'][2], 1)
    SetPedComponentVariation(ped, 7, character['comp7'][1], character['comp7'][2], 1)
    SetPedComponentVariation(ped, 8, character['comp8'][1], character['comp8'][2], 1)
    SetPedComponentVariation(ped, 9, character['comp9'][1], character['comp9'][2], 1)
    SetPedComponentVariation(ped, 10, character['comp10'][1], character['comp10'][2], 1)
    SetPedComponentVariation(ped, 11, character['comp11'][1], character['comp11'][2], 1)
    if character['prop0'][1] ~= -1 then
        SetPedPropIndex(ped, 1, character['prop0'][1], character['prop0'][2], 1)
    else
        ClearPedProp(ped, 1)
    end
    if character['prop1'][1] ~= -1 then
        SetPedPropIndex(ped, 2, character['prop1'][1], character['prop1'][2], 1)
    else
        ClearPedProp(ped, 2)
    end
    if character['prop2'][1] ~= -1 then
        SetPedPropIndex(ped, 3, character['prop2'][1], character['prop2'][2], 1)
    else
        ClearPedProp(ped, 3)
    end
    if character['prop6'][1] ~= -1 then
        SetPedPropIndex(ped, 6, character['prop6'][1], character['prop6'][2], 1)
    else
        ClearPedProp(ped, 6)
    end
    if character['prop7'][1] ~= -1 then
        SetPedPropIndex(ped, 7, character['prop7'][1], character['prop7'][2], 1)
    else
        ClearPedProp(ped, 7)
    end
end

function setPlayerSpecificComponent(compid, directory, texture)
    if compid ~= nil and directory ~= nil and texture ~= nil then
        if compid <= 11 then
            SetPedComponentVariation(PlayerPedId(), compid, directory, texture, 1)
            TriggerServerEvent('core.PlayerIsChangingClothes', {id = "comp"..compid, dr = directory, tx = texture})
        else
            SetPedPropIndex(PlayerPedId(), compid -12, directory, texture, 1)
        end
    else
        alert("nil found in Component Force")
    end
end

RegisterNetEvent('char.ForceCharacterComponent')
AddEventHandler("char.ForceCharacterComponent", function(_comp)
    if _comp.id ~= nil and _comp.drid ~= nil and _comp.txid ~= nil then
        setPlayerSpecificComponent(_comp.id, _comp.drid, _comp.txid)
    else
        alert("nil found in Component Force")
    end
end)

