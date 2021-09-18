charCoords = {
    [1] = {x = 113.721, y = -618.312, z = 206.046, h1 = 273.75, h2 = 234.548},
    [2] = {x = 114.781, y = -619.197, z = 206.046, h1 = 234.325, h2 = 234.548},
}

camCoords = {
    [1] = {x = 116.781, y = -617.99, z = 206.046, rx = 0.0, ry = 0.0, rz = 115.26},
    [2] = {x = 115.4, y = -619.58, z = 206.701, rx = 0.0, ry = 0.0, rz = 52.33},
}

isPlayerInCharacterCreation = false
cam1 = nil
cam2 = nil

--[[
RegisterCommand('meme', function(source, args)
    local id = GetPedHeadOverlayNum(1)
    print(id)
end)
]]

RegisterNetEvent('core.CharacterCreationResponse')

AddEventHandler('core.StartCharacterCreation', function()
    --code here.
    if isPlayerInCharacterCreation == false then
        isPlayerInCharacterCreation = true
        local ped = PlayerPedId()
        cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords[1].x, camCoords[1].y, camCoords[1].z, camCoords[1].rx, camCoords[1].ry, camCoords[1].rz, 70 * 1.0)
        cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords[2].x, camCoords[2].y, camCoords[2].z, camCoords[2].rx, camCoords[2].ry, camCoords[2].rz, 70 * 1.0)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, false)
        SetEntityCoords(ped, charCoords[1].x, charCoords[1].y, charCoords[1].z, false, false, false, false)
        SetEntityHeading(ped, charCoords[1].h1)
        --SetCamActive(cam2, true)
        SetCamActiveWithInterp(cam2, cam1, 5000, 1, 1)
        RenderScriptCams(true, false, 0, true, false)
        Citizen.CreateThread(function()
            Citizen.Wait(4000)
            TaskTurnPedToFaceCoord(ped, camCoords[2].x, camCoords[2].y, camCoords[2].z, 1000)
            TaskGoStraightToCoord(ped, charCoords[2].x, charCoords[2].y, charCoords[2].z, 0.8, 1, charCoords[2].h1, 0.0)
            TaskLookAtCoord(ped, camCoords[2].x, camCoords[2].y, camCoords[2].z, -1, 1, 1)
        end)
        while isPlayerInCharacterCreation do
            DisableAllControlActions(0)
            EnableControlAction(0, 191, true) --warmenu's select
            EnableControlAction(0, 199, true) --pause menu P
            EnableControlAction(0, 200, true) --pause menu ESC
            if not WarMenu.IsAnyMenuOpened() then
                alert('Press ~INPUT_ENTER~ to open the character creation menu')
                if IsDisabledControlJustPressed(0, 23) then
                    if not WarMenu.IsAnyMenuOpened() then
                        TriggerEvent('core.OpenCharCreationMenu')
                    end
                end
            elseif WarMenu.CurrentMenu() == "core.CharacterCreation01" then
                caption('Select a customization option, or save your character. You can also cancel it, and modify the character at a later date.', 10)
            elseif WarMenu.CurrentMenu() == "core.CharacterCreation02" then
                caption('Select your character model.', 10)
            elseif WarMenu.CurrentMenu() == "core.CharacterCreation03" then
                caption('Select your ~y~Mother~s~, ~y~Father~s~, ~y~F/M shape ratio~s~ and ~y~F/M skin tone ratio~s~.', 10)
            elseif WarMenu.CurrentMenu() == "core.CharacterCreation04" then
                caption('Face Features.\nHair and clothes are items that can be unlocked in the game.', 10)
            end
            Citizen.Wait(0)
        end
    end
end)

AddEventHandler('core.CharacterCreationResponse', function(bool, message)
    if bool == "passed" then
        isPlayerInCharacterCreation = false
        ClearFocus()
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam1, false)
        DestroyCam(cam1, false)
        TriggerEvent('core.respawn', true)
        notify('Character saved successfully.',123)
    elseif bool == "failed" then
        if message ~= nil then
            notify(tostring(message),8)
        else
            notify('Character creation failed.', 8)
        end
    elseif bool == "notokens" then
        notify("You don't have enough character tokens.", 8)
    end
end)

RegisterCommand('createcharacter', function()
    if isPlayerInCharacterCreation == false then
        TriggerEvent('core.StartCharacterCreation')
    else
        isPlayerInCharacterCreation = false
    end
end)

defaultCharacter = {
    ['mp_m_freemode_01'] = {
        ['model'] = 'mp_m_freemode_01',
        ['blend'] = {21,0,0.9,0.9}, --motherID, fatherID, shapeMix, skinMix,
        ['hair'] = {1, 255, 1, 255, 0}, --head hair, facial hair, eyebrows, chest hair, hair color.
        ['overlay'] = {255, 255, 255, 0, 255, 0, 255, 255, 255, 0, 255}, --blemishes, ageing, makeup, makeupColor, blush, blushColor, complexion, sun damage, lipstick, lipstickColor, moles
        ['overlayColor'] = {0,0,0,0,0,0},
        ['comp1'] = {0,0},
        ['comp2'] = {2,0},
        ['comp3'] = {1,0},
        ['comp4'] = {9,7},
        ['comp5'] = {0,0},
        ['comp6'] = {25,0},
        ['comp7'] = {0,0}, --125,0
        ['comp8'] = {32,0},
        ['comp9'] = {0,0}, --54,0
        ['comp10'] = {0,0}, --8,0
        ['comp11'] = {115,0},
        ['prop0'] = {-1,0}, -- -1 = no prop
        ['prop1'] = {-1,0},
        ['prop2'] = {-1,0},
        ['prop6'] = {-1,0},
        ['prop7'] = {-1,0},
    },
    ['mp_f_freemode_01'] = {
        ['model'] = 'mp_f_freemode_01',
        ['blend'] = {21,0,0.1,0.1}, --motherID, fatherID, shapeMix, skinMix,
        ['hair'] = {10, 255, 1, 255, 0, 0}, --head hair, facial hair, eyebrows, chest hair, hair primary color, hair secondary color.
        ['overlay'] = {255, 255, 255, 0, 255, 0, 255, 255, 255, 0, 255}, --blemishes, ageing, makeup, makeupColor, blush, blushColor, complexion, sun damage, lipstick, lipstickColor, moles
        ['overlayColor'] = {0,0,0,0,0,0},
        ['comp1'] = {0,0},
        ['comp2'] = {10,0},
        ['comp3'] = {3,0},
        ['comp4'] = {136,0},
        ['comp5'] = {0,0},
        ['comp6'] = {25,0},
        ['comp7'] = {0,0}, --125,0
        ['comp8'] = {39,0},
        ['comp9'] = {0,0}, --54,0
        ['comp10'] = {0,0}, --8,0
        ['comp11'] = {107,0},
        ['prop0'] = {-1,0}, -- -1 = no prop
        ['prop1'] = {-1,0},
        ['prop2'] = {-1,0},
        ['prop6'] = {-1,0},
        ['prop7'] = {-1,0},
    },
}