Citizen.CreateThread(function()
    while true do
        if playerNearOutpost ~= nil then
            local coords = GetEntityCoords(PlayerPedId())
            local c1 = vector3(outposts[playerNearOutpost].x1, outposts[playerNearOutpost].y1, outposts[playerNearOutpost].z1)
            local c2 = vector3(outposts[playerNearOutpost].x2, outposts[playerNearOutpost].y2, outposts[playerNearOutpost].z2)
            if outposts[playerNearOutpost].status == 0 then --enemy, need to break the first relay
                if #(c1 - coords) <= 5.0 then
                    alert('~INPUT_ENTER~ Break enemy broadcaster.')
                    if IsControlJustPressed(0--[[control type]],  23--[[control index]]) then
                        TriggerServerEvent("outpost.DestroyingBroadcaster", playerNearOutpost)
                        useButton(1)
                    end
                else
                    caption('Destroy the ~r~enemy broadcaster~s~, to prevent them from respawning.', 10)
                end
            elseif outposts[playerNearOutpost].status == 1 then --neutral. need to install Division relay.
                if #(c2 - coords) <= 5.0 then
                    alert('~INPUT_ENTER~ Liberate outpost.')
                    if IsControlJustPressed(0--[[control type]],  23--[[control index]]) then
                        TriggerServerEvent("outpost.InstallingBroadcaster", playerNearOutpost)
                        useButton(2)
                    end
                else
                    caption('Shoot a ~b~flare gun~s~ at the top of the outpost, to reclaim it.', 10)
                end
            elseif outposts[playerNearOutpost].status == 2 then --friendly. Just wait.
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)

function useButton(use)
    if use == 1 then
        local coords = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        TaskPlantBomb(PlayerPedId(), coords.x, coords.y, coords.z, heading)
        caption('Destroying enemy broadcaster...', 4000)
        Citizen.Wait(4000)
        --ClearPedTasks(PlayerPedId())
        TriggerServerEvent("outpost.DestroyedBroadcaster", playerNearOutpost)
    elseif use == 2 then
        TaskPlantBomb(PlayerPedId(), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
        caption('Preparing flare...', 4000)
        Citizen.Wait(4000)
        TriggerServerEvent("outpost.InstalledBroadcaster", playerNearOutpost)
        Citizen.Wait(200)
        local coords = GetEntityCoords(PlayerPedId())
        SetPlayerControl(PlayerId(), false, 1)
        TaskAimGunAtCoord(PlayerPedId(), coords.x, coords.y, coords.z+1000.0, 4000, true, true)
        Citizen.Wait(1000)
        TaskShootAtCoord(PlayerPedId(), coords.x, coords.y, coords.z+1000.0, 3000, "FIRING_PATTERN_SINGLE_SHOT")
        Citizen.Wait(500)
        SetPlayerControl(PlayerId(), true, 1)
    end
end