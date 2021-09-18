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

AddEventHandler('core.UpdatePlayerPed', function(data)
    PlayerInfo.ped = data
    setPlayerClothes(PlayerInfo.ped)
end)

AddEventHandler("playerSpawned", function(spawnInfo)
    Citizen.CreateThread(function()
        setPlayerCharacter(PlayerInfo.ped)
    end)
end)

RegisterCommand('player', function()
    Citizen.CreateThread(function()
        RequestModel('mp_m_freemode_01')
        while not HasModelLoaded('mp_m_freemode_01') do
            RequestModel('mp_m_freemode_01')
            Wait(0)
        end
        SetPlayerModel(PlayerId(), 'mp_m_freemode_01')
        SetModelAsNoLongerNeeded('mp_m_freemode_01')

        SetPedHeadBlendData(PlayerPedId(), 21, 0, 0, 21, 0, 0, 1.0, 1.0, 0.0, false)
    end)
end)