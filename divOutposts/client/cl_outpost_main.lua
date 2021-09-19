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
                    alert('~INPUT_ENTER~ Instal Division broadcaster.')
                    if IsControlJustPressed(0--[[control type]],  23--[[control index]]) then
                        TriggerServerEvent("outpost.InstallingBroadcaster", playerNearOutpost)
                        useButton(2)
                    end
                else
                    caption('Install a ~b~DivisionTech broadcaster~s~, to claim this outpost.', 10)
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
        print('pressed button')
        local wait = 4000
        caption('Destroying enemy broadcaster...', 4000)
        Citizen.Wait(4000)
        print('sent Event')
        TriggerServerEvent("outpost.DestroyedBroadcaster", playerNearOutpost)
    elseif use == 2 then
        local wait = 4000
        while wait <= 0 do
            wait = wait -1
            
            Citizen.Wait(1)
        end
        print('pressed button')
        caption('Installing Division broadcaster...', 4000)
        Citizen.Wait(4000)
        print('sent Event')
        TriggerServerEvent("outpost.InstalledBroadcaster", playerNearOutpost)
    end
end