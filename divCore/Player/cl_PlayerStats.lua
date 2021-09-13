RegisterNetEvent('core.GetInitialStats')
RegisterNetEvent('core.UpdatePlayerPed')

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