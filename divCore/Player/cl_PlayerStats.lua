RegisterNetEvent('core.GetInitialStats')
RegisterNetEvent('core.UpdateClientResources')
RegisterNetEvent('core.UpdatePlayerPed')

coreMenuStyle = {titleColor = {255, 255, 255}, subTitleColor = {255, 255, 255}, titleBackgroundSprite = {dict = 'commonmenu', name = 'interaction_bgd'}}
PlayerInfo = {
    uid = 0,
    name = "console",
    bantime = 0,
    mutetime = 0,
    stats = {},
    weapons = {},
    clothes = {},
    ped = {},
    lang = 'en',
    admin = 0,
    license = "license:99999999999999999",
}

PlayerData = { --this array is used for temporary data that I might need at *some* point, like the task the player has to do when respawning.
    respawnTask  = {}, 
}

Citizen.CreateThread( function()
    while true do
       Citizen.Wait(500)
       RestorePlayerStamina(PlayerId(), 1.0)
       end
end)

AddEventHandler('core.GetInitialStats', function(_info)
    PlayerInfo = _info
    updateStatsUI(true, tonumber(PlayerInfo.stats['xp']), tonumber(PlayerInfo.stats['cash']), tonumber(PlayerInfo.stats['bank']))
    TriggerEvent('core.notify', "simple", {text = "Client Synced.\nWelcome ["..PlayerInfo.uid.."]"..PlayerInfo.name.."!", colID = 123})
    TriggerEvent('core.respawn', true)
end)

AddEventHandler('core.UpdateClientResources', function(_info, _showNotification)
    local sendLevelUpdate = false
    if PlayerInfo.stats['xp'] ~= _info.stats['xp'] then
        sendLevelUpdate = true
    end
    PlayerInfo = _info
    updateStatsUI(false, tonumber(PlayerInfo.stats['xp']), tonumber(PlayerInfo.stats['cash']), tonumber(PlayerInfo.stats['bank']))
    if sendLevelUpdate == true then
        TriggerServerEvent('core.SendLevelUpdate', exports.XNLRankBar:Exp_XNL_GetCurrentPlayerLevel())
        PlayerInfo.stats['level'] = exports.XNLRankBar:Exp_XNL_GetCurrentPlayerLevel()
    end
    if _showNotification ~= nil then
        if _showNotification == true then
            TriggerEvent('core.notify', "simple", {text = "Client Synced.", colID = 123})
        end
    else
        TriggerEvent('core.notify', "simple", {text = "Client Synced.", colID = 123})
    end
end)

--------------------------
RegisterCommand("coords", function(source, args)
    coords = GetEntityCoords(PlayerPedId()) 
    rotaion = GetEntityRotation(PlayerPedId()) 
    heading = GetEntityHeading(PlayerPedId()) 
    chatMessage("COORDONATES", string.format("x: %f | y: %f | z:%f | heading: %f", coords.x,coords.y,coords.z, heading), 255, 255, 255)
    chatMessage("ROTATION", string.format("x: %f | y: %f | z:%f", rotaion.x,rotaion.y,rotaion.z), 255, 255, 255)
end, false)
-------------------------

AddEventHandler('core.UpdatePlayerPed', function(data)
    PlayerInfo.ped = data
    setPlayerClothes(PlayerInfo.ped)
end)

AddEventHandler("playerSpawned", function(spawnInfo)
    setPlayerCharacter(PlayerInfo.ped)
    TriggerServerEvent('core.RequestSpawnLoadout') --in PlayerArmory
    if PlayerData.respawnTask ~= nil then
        setPlayerRespawnTask(PlayerData.respawnTask)
    end
end)

function setPlayerRespawnTask(data)
    if data.task == "walkToCoord" then
        TaskFollowNavMeshToCoord(PlayerPedId(), data.x, data.y, data.z, 0.8, 6000, 1.0, false, 1)
        Citizen.Wait(4000)
        TaskAchieveHeading(PlayerPedId(), data.h, 1000)
    end
end