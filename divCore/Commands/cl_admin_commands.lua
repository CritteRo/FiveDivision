RegisterNetEvent("core.tpToWaypoint")

AddEventHandler("core.tpToWaypoint", function()
    if PlayerInfo.admin >= 2 then
        local WaypointHandle = GetFirstBlipInfoId(8)
        if DoesBlipExist(WaypointHandle) then
            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
            for height = 1, 1000 do
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                if foundGround then
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                    break
                end
                Citizen.Wait(5)
            end
            notify("Teleported.")
            SetEntityInvincible(PlayerPedId(), true)
            Citizen.Wait(3000)
            SetEntityInvincible(PlayerPedId(), false)
            notify("God mode off")
        else
            notify("Please place your waypoint.", 8)
        end
    end
end)