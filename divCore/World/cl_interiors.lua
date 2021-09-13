interiors = {
    [1] = {name = "FIB Safezone", x1 = 136.127, y1 = -761.478, z1 = 45.752, x2 = 136.034, y2 = -761.646, z2 = 242.152},
    --[2] = {name = "Downtown Contruction Site", x1 = -180.98, y1 = -1016.64, z1 = 29.28, x2 = -154.901, y2 = -943.57, z2 = 269.14},
}

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