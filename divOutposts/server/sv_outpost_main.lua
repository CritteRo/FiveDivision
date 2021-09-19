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
    end
    local updateTime = 60*1000
    while true do
        Citizen.Wait(updateTime) --30 seconds, update one neutral or friendly outpost
        local rand = math.random(1, #outposts)
        if outposts[rand].status ~= 0 then
            if outposts[rand].status == 1 then
                outposts[rand].status = 0
                spawnOutpostEnemies(rand)
                local email = {title = 'Dispatch Outpost Status ', to = 'everyone', from = "Dispatch", message = "Outpost "..outposts[rand].name.." was captured!"}
                TriggerClientEvent('phone.ReceiveEmail', -1, email)
            elseif outposts[rand].status == 2 then
                outposts[rand].status = 1
                local email = {title = 'Dispatch Outpost Status ', to = 'everyone', from = "Dispatch", message = "Outpost "..outposts[rand].name.." was abandoned!\n\nIf you don't reclaim it, the enemies will!"}
                TriggerClientEvent('phone.ReceiveEmail', -1, email)
            end
            TriggerClientEvent('outpost.ReloadOutpostBlips', -1, outposts)
        end
    end
end)

AddEventHandler('outpost.RequestServerOutposts', function()
    local src = source
    TriggerClientEvent('outpost.ReloadOutpostBlips', src, outposts)
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
    if PlayerInfo[src] ~= nil then
        if PlayerInfo[src].isInstalling == true then
            if PlayerInfo[src].inOutpost ~= 0 then
                local finishTimer = GetGameTimer()
                if finishTimer - PlayerInfo[src].installingStart >= 2000 then
                    if outposts[PlayerInfo[src].inOutpost].status == 1 then
                        outposts[PlayerInfo[src].inOutpost].status = 2
                        PlayerInfo[src].isInstalling = false
                        PlayerInfo[src].installingStart = 0
                        PlayerInfo[src].inOutpost = 0
                        TriggerClientEvent('outpost.ReloadOutpostBlips', -1, outposts)
                    end
                end
            end
        end
    end
end)

function spawnOutpostEnemies(outpostID)
end