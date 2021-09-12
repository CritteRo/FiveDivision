RegisterNetEvent('core.GetInitialStats')

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
    print('data received')
    print(tostring(PlayerInfo.uid))
end)

AddEventHandler("playerSpawned", function(spawnInfo)
    Citizen.CreateThread(function()
        --[[RequestModel('mp_m_freemode_01')
        while not HasModelLoaded('mp_m_freemode_01') do
            RequestModel('mp_m_freemode_01')
            Wait(0)
        end
        SetPlayerModel(PlayerId(), 'mp_m_freemode_01')
        SetModelAsNoLongerNeeded('mp_m_freemode_01')
        SetPedHeadBlendData(PlayerPedId(), 21, 0, 0, 21, 0, 0, 1.0, 1.0, 0.0, false)]]
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