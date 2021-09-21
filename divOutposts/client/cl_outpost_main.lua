RegisterNetEvent('outpost.ReloadOutpostPeds')

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
        TaskAimGunAtCoord(PlayerPedId(), coords.x, coords.y, coords.z+1000.0, 1000, true, true)
        TaskShootAtCoord(PlayerPedId(), coords.x, coords.y, coords.z+1000.0, 1000, "FIRING_PATTERN_SINGLE_SHOT")
        Citizen.Wait(500)
        SetPlayerControl(PlayerId(), true, 1)
    end
end

AddEventHandler('outpost.ReloadOutpostPeds', function(peds)
    enemySpawns = peds
end)

retval, enemyGroupR = AddRelationshipGroup('enemies')
retmeme, myGroupR = AddRelationshipGroup('enemies')
SetRelationshipBetweenGroups(5--[[hate]], myGroupR, enemyGroupR)
SetRelationshipBetweenGroups(5--[[hate]], enemyGroupR, myGroupR)
SetRelationshipGroupDontAffectWantedLevel(myGroupR, true)
SetRelationshipGroupDontAffectWantedLevel(enemyGroupR, true)

enemyGroup = -1
myGroup = -1

AddEventHandler('outpost.SetPedBehavior', function(outpost)
    print('ped behavior set')
    if DoesGroupExist(enemyGroup) then
        RemoveGroup(enemyGroup)
    end
    if IsPedInGroup(PlayerPedId()) then
        myGroup = GetPedGroupIndex(PlayerPedId())
    else
        myGroup = CreateGroup(0--[[unused]])
        SetPedAsGroupMember(PlayerPedId(), myGroup)
        SetPedRelationshipGroupHash(PlayerPedId(), myGroupR)
        SetPedConfigFlag(PlayerPedId(), 13, true)
    end
    enemyGroup = CreateGroup(0--[[unused]])
    SetRelationshipBetweenGroups(5--[[hate]], myGroup, enemyGroup)
    SetRelationshipBetweenGroups(5--[[hate]], enemyGroup, myGroup)
    SetRelationshipGroupDontAffectWantedLevel(myGroup, true)
    SetRelationshipGroupDontAffectWantedLevel(enemyGroup, true)
    for i,k in pairs(enemySpawns[outpost]) do
        if IsEntityAPed(k.handle) then
            print('found ped '..k.handle)
            SetPedAsGroupMember(k.handle, enemyGroup)
            SetPedRelationshipGroupHash(k.handle, enemyGroupR)
            SetPedConfigFlag(k.handle, 13, true)
            SetPedAsEnemy(k.handle, true)
            SetPedCombatMovement(k.handle, math.random(1,3))
        end
    end
    SetRelationshipBetweenGroups(5--[[hate]], myGroupR, enemyGroupR)
    SetRelationshipBetweenGroups(5--[[hate]], enemyGroupR, myGroupR)
    SetRelationshipGroupDontAffectWantedLevel(myGroupR, true)
    SetRelationshipGroupDontAffectWantedLevel(enemyGroupR, true)
end)

AddEventHandler('outpost.SetPedBehavior_2', function(outpost)
    --print('ped behavior set 2')
    --if GetPedRelationshipGroupHash(PlayerPedId()) ~= myGroup then
        --SetPedRelationshipGroupHash(PlayerPedId(), myGroup)
    --end
    SetRelationshipBetweenGroups(5--[[hate]], GetHashKey("PLAYER"), GetHashKey('AMBIENT_GANG_BALLAS'))
    SetRelationshipBetweenGroups(5--[[hate]], GetHashKey('AMBIENT_GANG_BALLAS'), GetHashKey("PLAYER"))
    for i,k in pairs(enemySpawns[tonumber(outpost)]) do
        print('checking ped '..k.handle)
        local retest = 0
        ::recheck::
        if IsEntityAPed(NetToPed(k.handle)) then
            local ped = NetToPed(k.handle)
            print('found ped '..ped)
            SetPedRelationshipGroupHash(ped, GetHashKey('AMBIENT_GANG_BALLAS'))
            SetPedAsEnemy(ped, true)
            SetPedCombatMovement(ped, math.random(1,3))
        else
            if retest < 11 then
                print('rechecking ped '..k.handle)
                Citizen.Wait(10)
                retest = retest + 1
                goto recheck
            else
                print("couldn't find "..k.handle)
            end
        end
    end
    SetRelationshipGroupDontAffectWantedLevel(GetHashKey("PLAYER"), true)
    SetRelationshipGroupDontAffectWantedLevel(GetHashKey('AMBIENT_GANG_BALLAS'), true)
end)

RegisterNetEvent('test.SendPedToClient')
AddEventHandler('test.SendPedToClient', function(_ped)
    print(_ped)
    while not DoesEntityExist(NetToPed(_ped)) do 
            Wait(10)
    end
    local ped = NetToPed(_ped)
    if DoesEntityExist(ped) then
        print(ped.." is an entity")
    else
        print(ped.." is NOT entity")
    end

    if DoesEntityExist(tonumber(ped)) then
        print(ped.." is an tonumber entity")
    else
        print(ped.." is NOT tonumber entity")
    end

    if IsEntityAPed(ped) then
        print(ped.." is an ped")
    else
        print(ped.." is NOT ped")
    end

    if IsEntityAPed(tonumber(ped)) then
        print(ped.." is an tonumber ped")
    else
        print(ped.." is NOT tonumber ped")
    end
end)