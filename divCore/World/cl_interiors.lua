interiors = {
    [1] = {name = "FIB Safezone", x1 = 136.127, y1 = -761.478, z1 = 45.752, x2 = 136.034, y2 = -761.646, z2 = 242.152, blip = 40, blipColor = 0, refID = "fib_safezone_1"},
    --[2] = {name = "Downtown Contruction Site", x1 = -180.98, y1 = -1016.64, z1 = 29.28, x2 = -154.901, y2 = -943.57, z2 = 269.14},
}

interiorBlips = {}

Citizen.CreateThread(function()
    for i,k in pairs(interiors) do
        interiorBlips[i] = createBlip(k.name, k.blip, k.x1, k.y1, k.z1, k.blipColor)
    end
end)

Citizen.CreateThread(function()
    while true do
        local pedCoords = GetEntityCoords(PlayerPedId())
        local foundCoord = false
        for i,k in pairs(interiors) do
            foundCoord = false
            if #(vector3(k.x1, k.y1, k.z1) - pedCoords) <=5.01 then
                alert(inputAlerts[PlayerInfo.lang].enterSafehouse)
                foundCoord = true
                if IsControlJustPressed(0--[[control type]],  23--[[control index]]) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(1)
                    end
                    SetEntityCoords(PlayerPedId(), k.x2, k.y2, k.z2, false, false, false, false)
                    DoScreenFadeIn(500)
                    notify("Teleported to ~y~"..k.name.."~s~.", 123)
                    TriggerServerEvent('core.PlayerEnteredInterior', k.refID)
                end
                break
            elseif #(vector3(k.x2, k.y2, k.z2) - pedCoords) <=5.01 then
                alert(inputAlerts[PlayerInfo.lang].exitSafehouse)
                foundCoord = true
                if IsControlJustPressed(0--[[control type]],  23--[[control index]]) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(1)
                    end
                    SetEntityCoords(PlayerPedId(), k.x1, k.y1, k.z1, false, false, false, false)
                    DoScreenFadeIn(500)
                    notify("Teleported back from ~y~"..k.name.."~s~.", 123)
                    TriggerServerEvent('core.PlayerExitedInterior', k.refID)
                end
                break
            end
        end
        if foundCoord == false then
            Citizen.Wait(200)
        end
        Citizen.Wait(0)
    end
end)

function createBlip(name, blip, x, y, z, color)
    local _blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(_blip, blip)
    SetBlipDisplay(_blip, 4)
    SetBlipScale(_blip, 0.9)
    SetBlipColour(_blip, color)
    SetBlipAsShortRange(_blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(_blip)

    return _blip
end