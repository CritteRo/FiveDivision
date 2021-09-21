PlayerInfo = {
    [0] = {
        name = "console",
        uid = 0,
        stats = {},
        destroyingStart = 0,
        isDestroying = false,
        installingStart = 0,
        isInstalling = false,
        inOutpost = 0,
    }
}

RegisterNetEvent('outpost.DestroyingBroadcaster')
RegisterNetEvent('outpost.DestroyedBroadcaster')
RegisterNetEvent('outpost.InstallingBroadcaster')
RegisterNetEvent('outpost.InstalledBroadcaster')
RegisterNetEvent('outpost.RequestServerOutposts')

AddEventHandler('core.UpdateServerResources', function(_src, _info)
    if PlayerInfo[tonumber(_src)] ~= nil then
        PlayerInfo[tonumber(_src)].stats = _info.stats
    else
        PlayerInfo[tonumber(_src)] = {
            name = _info.name,
            uid = _info.uid,
            stats = _info.stats,
            destroyingStart = 0,
            isDestroying = false,
            installingStart = 0,
            isInstalling = false,
            inOutpost = 0,
        }
    end
end)


Citizen.CreateThread(function()
    for i,k in pairs(outposts) do
        outposts[i].status = 0
        spawnOutpostEnemies(i, 1)
    end
    local updateTime = 5*60*1000
    while true do
        Citizen.Wait(updateTime) --60 seconds, update one neutral or friendly outpost
        local rand = math.random(1, #outposts)
        if outposts[rand].status ~= 0 then
            if outposts[rand].status == 1 then
                outposts[rand].status = 0
                spawnOutpostEnemies(rand, 1)
                local email = {title = 'Dispatch Outpost Status ', to = 'everyone', from = "Dispatch", message = "Outpost "..outposts[rand].name.." was captured!"}
                TriggerClientEvent('phone.ReceiveEmail', -1, email)
            elseif outposts[rand].status == 2 then
                outposts[rand].status = 1
                local email = {title = 'Dispatch Outpost Status ', to = 'everyone', from = "Dispatch", message = "Outpost "..outposts[rand].name.." was abandoned!\n\nIf you don't reclaim it, the enemies will!"}
                TriggerClientEvent('phone.ReceiveEmail', -1, email)
            end
            TriggerClientEvent('outpost.ReloadOutpostBlips', -1, outposts)
            TriggerClientEvent('outpost.ReloadOutpostPeds', -1, enemySpawns)
        end
    end
end)

AddEventHandler('outpost.RequestServerOutposts', function()
    local src = source
    TriggerClientEvent('outpost.ReloadOutpostBlips', src, outposts)
    TriggerClientEvent('outpost.ReloadOutpostPeds', src, enemySpawns)
end)

AddEventHandler('outpost.DestroyingBroadcaster', function(outpostID)
    --when you start destroying it
    local src = source
    if PlayerInfo[src] ~= nil then
        if PlayerInfo[src].isDestroying == false and PlayerInfo[src].isInstalling == false then
            local coords = GetEntityCoords(GetPlayerPed(src))
            for i,k in pairs(outposts) do
                if #(vector3(k.x1, k.y1, k.z1)-coords) <= 10.0 then
                    PlayerInfo[src].inOutpost = i
                    break
                end
            end
            if PlayerInfo[src].inOutpost == tonumber(outpostID) then
                PlayerInfo[src].isDestroying = true
                PlayerInfo[src].destroyingStart = GetGameTimer()
            else
                print('incorrect outpost. '..PlayerInfo[src].inOutpost.." vs "..outpostID)
            end
        end
    end
end)

AddEventHandler('outpost.DestroyedBroadcaster', function(outpostID)
    local src = source
    ClearPedTasks(GetPlayerPed(src))
    if PlayerInfo[src] ~= nil then
        if PlayerInfo[src].isDestroying == true then
            if PlayerInfo[src].inOutpost ~= 0 then
                local finishTimer = GetGameTimer()
                if finishTimer - PlayerInfo[src].destroyingStart >= 2000 then
                    if outposts[PlayerInfo[src].inOutpost].status == 0 then
                        print(PlayerInfo[src].inOutpost)
                        outposts[PlayerInfo[src].inOutpost].status = 1
                        PlayerInfo[src].isDestroying = false
                        PlayerInfo[src].destroyingStart = 0
                        PlayerInfo[src].inOutpost = 0
                        TriggerClientEvent('outpost.ReloadOutpostBlips', -1, outposts)
                    end
                end
            end
        end
    end
end)

AddEventHandler('outpost.InstallingBroadcaster', function(outpostID)
    --when you start destroying it
    local src = source
    if PlayerInfo[src] ~= nil then
        if PlayerInfo[src].isDestroying == false and PlayerInfo[src].isInstalling == false then
            local coords = GetEntityCoords(GetPlayerPed(src))
            for i,k in pairs(outposts) do
                if #(vector3(k.x2, k.y2, k.z2)-coords) <= 10.0 then
                    PlayerInfo[src].inOutpost = i
                    break
                end
            end
            if PlayerInfo[src].inOutpost == tonumber(outpostID) then
                PlayerInfo[src].isInstalling = true
                PlayerInfo[src].installingStart = GetGameTimer()
            else
                print('incorrect outpost. '..PlayerInfo[src].inOutpost.." vs "..outpostID)
            end
        end
    end
end)

AddEventHandler('outpost.InstalledBroadcaster', function(outpostID)
    local src = source
    local ped = GetPlayerPed(src)
    ClearPedTasks(ped)
    if PlayerInfo[src] ~= nil then
        if PlayerInfo[src].isInstalling == true then
            if PlayerInfo[src].inOutpost ~= 0 then
                local finishTimer = GetGameTimer()
                if finishTimer - PlayerInfo[src].installingStart >= 2000 then
                    if outposts[PlayerInfo[src].inOutpost].status == 1 then
                        outposts[PlayerInfo[src].inOutpost].status = 2
                        PlayerInfo[src].isInstalling = false
                        PlayerInfo[src].installingStart = 0
                        TriggerClientEvent('outpost.ReloadOutpostBlips', -1, outposts)
                        TriggerClientEvent('outpost.ReloadOutpostPeds', -1, enemySpawns)
                        ClearPedTasks(ped)
                        --local coords = GetEntityCoords(ped)
                        --SetPlayerControl(src, false, 1)
                        --RemoveWeaponFromPed(ped, "weapon_flaregun")
                        --GiveWeaponToPed(ped, "weapon_flaregun", 1, false, true)
                        --TaskShootAtCoord(ped, coords.x, coords.y, coords.z+1000.0, 3000, "FIRING_PATTERN_SINGLE_SHOT")
                        --Citizen.Wait(100)
                        --SetPlayerControl(src, true, 1)
                        Citizen.Wait(5000)
                        TriggerClientEvent('cS.MidsizeBanner', src, "OUTPOST LIBERATED", outposts[PlayerInfo[src].inOutpost].name, 123, 12, true)
                        PlayerInfo[src].inOutpost = 0
                    end
                end
            end
        end
    end
end)

function spawnOutpostEnemies(outpostID, factionID)
    if enemySpawns[outpostID] ~= nil then
        for i,k in pairs(enemySpawns[outpostID]) do
            if DoesEntityExist(NetworkGetEntityFromNetworkId(k.handle)) then
                if not IsEntityVisible(NetworkGetEntityFromNetworkId(k.handle)) or GetEntityHealth(NetworkGetEntityFromNetworkId(k.handle)) <= 0 then
                    DeleteEntity(NetworkGetEntityFromNetworkId(k.handle))
                    k.handle = CreatePed(1, factionPeds[1][1]--[[when factions are added, this is where you will find the ped of factionID]], k.x, k.y, k.z, math.random(0,200)+0.0, true, false)
                    GiveWeaponToPed(k.handle, factionPeds[1][2], 100, false, true)
                    SetPedArmour(k.handle, 100)
                end
            else
                k.handle = CreatePed(1, factionPeds[1][1], k.x, k.y, k.z, math.random(0,200)+0.0, true, false)
                SetPedRandomComponentVariation(k.handle, 0)
                GiveWeaponToPed(k.handle, factionPeds[1][2], 100, false, true)
                SetPedArmour(k.handle, 100)
            end
        end
        for v,h in pairs(enemySpawns[outpostID]) do
            if DoesEntityExist(h.handle) then
                h.handle = NetworkGetNetworkIdFromEntity(h.handle)
            end
        end
        TriggerClientEvent('outpost.ReloadOutpostPeds', -1, enemySpawns)
    else
        print('outpost has no enemies')
    end
end

function createPed(player)
    local src = player
    local coords = GetEntityCoords(GetPlayerPed(src))
    local ped = CreatePed(1, factionPeds[1][1]--[[when factions are added, this is where you will find the ped of factionID]], coords.x, coords.y, coords.z, math.random(0,200)+0.0, true, false)
    print(ped..' is server ped id')
    print(NetworkGetNetworkIdFromEntity(ped).."is ped net id")
    TriggerClientEvent('test.SendPedToClient', src, NetworkGetNetworkIdFromEntity(ped))
end

RegisterCommand('ped', function(source, args)
    createPed(source)
end)

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        print(name)
        for v,h in pairs(enemySpawns) do
            for i,k in pairs(h) do
                if DoesEntityExist(NetworkGetEntityFromNetworkId(k.handle)) then
                    DeleteEntity(NetworkGetEntityFromNetworkId(k.handle))
                end
            end
        end
    end
end)