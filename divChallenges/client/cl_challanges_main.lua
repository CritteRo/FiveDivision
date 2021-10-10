RegisterNetEvent('challange.SendChallengesToClient')
RegisterNetEvent('challange.SendChallengeUsersToClient')
RegisterNetEvent('challange.GetServerTime')
RegisterNetEvent('core.GetInitialStats')
RegisterNetEvent('core.UpdateClientResources')

PlayerInfo = {}

AddEventHandler('challange.SendChallengesToClient', function(_data)
    sharedChallenges = _data
    for i,k in pairs(sharedChallenges) do
        print(k.status)
    end
    Citizen.Wait(1000)
    TriggerEvent('challange.UpdateChallengePhoneApp')
end)

AddEventHandler('challange.SendChallengeUsersToClient', function(_data)
    sharedChallengeUsers = _data
    TriggerEvent('challange.UpdateChallengePhoneApp')
end)

AddEventHandler('challange.GetServerTime', function(_time)
    sharedCurrentServerTime = tonumber(_time)
end)

AddEventHandler('core.GetInitialStats', function(_info)
    PlayerInfo = _info
    TriggerServerEvent('challange.ProvideChallenges')
end)

AddEventHandler('core.UpdateClientResources', function(_info, _showNotification)
    PlayerInfo = _info
    --TriggerServerEvent('challange.ProvideChallenges')
end)