RegisterNetEvent('challange.RequestAllChallenges')
RegisterNetEvent('challange.SendChallengeUsersToClient')

AddEventHandler('challange.RequestAllChallenges', function(_data)
    sharedChallenges = _data
end)

AddEventHandler('challange.SendChallengeUsersToClient', function(_data)
    sharedChallengeUsers = _data
end)