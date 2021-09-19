outpostBlips = {
    --{[1] = blipID, [2] = checkpoint1, [3] = checkpoint2},
}
playerNearOutpost = nil
lastOutpost = 0
outpostScaleform = 0


Citizen.CreateThread(function()
    TriggerEvent('outpost.ReloadOutpostBlips')
    outpostScaleform = Scaleform.Request('MP_MISSION_NAME_FREEMODE')
    while true do
        playerNearOutpost = nil
        local coords = GetEntityCoords(PlayerPedId())
        for i,k in pairs(outposts) do
            local dist = #(vector3(k.blipX, k.blipY, k.blipZ)-coords)
            if dist <= 120.0 then
                playerNearOutpost = i
                if lastOutpost ~= i then
                    lastOutpost = i
                    outpostScaleform = Scaleform.Request('MP_MISSION_NAME_FREEMODE')
                    Scaleform.CallFunction(outpostScaleform, false, "SET_MISSION_INFO", outpostStatusName[k.status].."\n", outpostStatusColor[k.status]..k.name.."~s~", "", '', "", false, "", k.xp, k.cash,"")
                end
                break
            end
        end
        if playerNearOutpost ~=nil then
            local dist = #(vector3(outposts[playerNearOutpost].blipX, outposts[playerNearOutpost].blipY, outposts[playerNearOutpost].blipZ) - coords)
            if dist >=30.0 then
                local camcoord = GetFinalRenderedCamRot(2)
                DrawScaleformMovie_3dSolid(outpostScaleform, outposts[playerNearOutpost].blipX, outposts[playerNearOutpost].blipY, outposts[playerNearOutpost].blipZ+5, camcoord, 1.0, 1.0, 15.0, 15.0, 15.0, 100)
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler('outpost.ReloadOutpostBlips', function()
    for i,k in pairs(outposts) do
        local color = 3 --liberated
        local img = 417 --liberated
        if k.status == 1 then
            color = 0 --contested / abandoned
            img = 418
        elseif k.status == 0 then
            color = 1
            img = 418
        end
        if outpostBlips[i] ~= nil then
            if outpostBlips[i][1] ~= nil then
                RemoveBlip(outpostBlips[i][1])
                DeleteCheckpoint(outpostBlips[i][2])
                DeleteCheckpoint(outpostBlips[i][3])
            end
            outpostBlips[i][1] = createStaticBlip(k.name, img, k.blipX, k.blipY, k.blipZ, color, 0.9)
            if k.status ~= 2 then
                outpostBlips[i][2] = CreateCheckpoint(5, k.x1, k.y1, k.z1, 0.0, 0.0, 0.0, 3.01, 255, 190, 100, 60, 0)
                SetCheckpointCylinderHeight(outpostBlips[i][2], 2.01, 6.01, 3.01)
                SetCheckpointIconRgba(outpostBlips[i][2], 200, 0, 0, 130)
                outpostBlips[i][3] = CreateCheckpoint(11, k.x2, k.y2, k.z2, 0.0, 0.0, 0.0, 3.01, 255, 190, 100, 60, 0)
                SetCheckpointCylinderHeight(outpostBlips[i][3], 2.01, 6.01, 3.01)
                SetCheckpointIconRgba(outpostBlips[i][3], 0, 175, 255, 130)
            end
        else
            outpostBlips[i] = {
                [1] = createStaticBlip(k.name, img, k.blipX, k.blipY, k.blipZ, color, 0.9),
            }
            if k.status ~= 2 then
                outpostBlips[i][2] = CreateCheckpoint(5, k.x1, k.y1, k.z1, 0.0, 0.0, 0.0, 3.01, 255, 190, 100, 60, 0)
                SetCheckpointCylinderHeight(outpostBlips[i][2], 2.01, 6.01, 3.01)
                SetCheckpointIconRgba(outpostBlips[i][2], 200, 0, 0, 130)
                outpostBlips[i][3] = CreateCheckpoint(11, k.x2, k.y2, k.z2, 0.0, 0.0, 0.0, 3.01, 255, 190, 100, 60, 0)
                SetCheckpointCylinderHeight(outpostBlips[i][3], 2.01, 6.01, 3.01)
                SetCheckpointIconRgba(outpostBlips[i][3], 0, 175, 255, 130)
            end
        end
        
    end
end)

outpostStatusName = {
    [0] = "Enemy Outpost",
    [1] = "Neutral Outpost",
    [2] = "Liberated Outpost",
}

outpostStatusColor = {
    [0] = "~r~",
    [1] = "~s~",
    [2] = "~b~",
}

function createStaticBlip(name, blip, x, y, z, color, size)
    _blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(_blip, blip)
    SetBlipDisplay(_blip, 4)
    SetBlipScale(_blip, size+0.0)
    SetBlipColour(_blip, color)
    SetBlipAsShortRange(_blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(_blip)

    return _blip
end

function notify(string, colID)
    if colID ~= nil then
        ThefeedSetNextPostBackgroundColor(colID)
    end
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(string)
    EndTextCommandThefeedPostTicker(true, true)
end

function caption(text, ms)
    BeginTextCommandPrint("string")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(ms, 1)
end

function alert(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

-----------SCALEFORM UTILS----------------------------------------------
Scaleform = {}
function Scaleform.Request(scaleform)
    local scaleform_handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Citizen.Wait(0)
    end
    return scaleform_handle
end
function Scaleform.CallFunction(scaleform, returndata, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = {...}

    if args ~= nil then
        for i = 1,#args do
            local arg_type = type(args[i])

            if arg_type == "boolean" then
                ScaleformMovieMethodAddParamBool(args[i])
            elseif arg_type == "number" then
                if not string.find(args[i], '%.') then
                    ScaleformMovieMethodAddParamInt(args[i])
                else
                    ScaleformMovieMethodAddParamFloat(args[i])
                end
            elseif arg_type == "string" then
                ScaleformMovieMethodAddParamTextureNameString(args[i])
            end
        end

        if not returndata then
            EndScaleformMovieMethod()
        else
            return EndScaleformMovieMethodReturnValue()
        end
    end
end