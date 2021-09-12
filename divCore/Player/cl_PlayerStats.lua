PlayerInfo = {
    [0] = {
        uid = 0,
        name = "console",
        bantime = 0,
        mutetime = 0,
        stats = {},
        weapons = {},
        clothes = {},
        char = {},
        lang = 'en',
        admin = 0,
        license = "license:99999999999999999",
    }
}

RegisterNetEvent('char.ForceCharacterComponent')
AddEventHandler("char.ForceCharacterComponent", function(_comp)
    if _comp.id ~= nil and _comp.drid ~= nil and _comp.txid ~= nil then
        if _comp.id <= 11 then
            SetPedComponentVariation(PlayerPedId(), _comp.id, _comp.drid, _comp.txid, 1)
        else
            SetPedPropIndex(PlayerPedId(), _comp.id - 12, _comp.drid, _comp.txid, 1)
        end
    else
        alert("nil found in Component Force")
    end
end)

AddEventHandler("playerSpawned", function(spawnInfo)
    Citizen.CreateThread(function()
        RequestModel('mp_m_freemode_01')
        while not HasModelLoaded('mp_m_freemode_01') do
            RequestModel('mp_m_freemode_01')
            Wait(0)
        end
        SetPlayerModel(PlayerId(), 'mp_m_freemode_01')
        SetModelAsNoLongerNeeded('mp_m_freemode_01')
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