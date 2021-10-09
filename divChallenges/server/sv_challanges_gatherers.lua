AddEventHandler('challenge.OutpostLiberated', function(oID, faction, mvp, others) --keep in mind that we only use 
    local challenges = {}
    local src = tonumber(mvp)
    for i,k in pairs(sharedChallenges) do
        if k.status == "active" then
            if k.missionType == "outpost" and k.missionCondition1 == "liberate" then
                if k.missionCondition2 == "any" or k.missionCondition2 == faction then
                    table.insert(challenges, i)
                end
            end
        end
    end

    for i,k in pairs(challenges) do --for outpost liberation, we only use dataPoint1
        if sharedChallengeUsers[k] ~= nil then
            if sharedChallengeUsers[k][PlayerInfo[src].uid] ~= nil then
                sharedChallengeUsers[k][PlayerInfo[src].uid].dataPoint1 = sharedChallengeUsers[k][PlayerInfo[src].uid].dataPoint1 + 1
            else
                sharedChallengeUsers[k][PlayerInfo[src].uid] = {uid = 0, pID = PlayerInfo[src].uid, name = PlayerInfo[src].name, challengeID = k, dataPoint1 = 1, dataPoint2 = 0, dataPoint3 = 0}
            end
        else
            sharedChallengeUsers[k] = {
                [PlayerInfo[src].uid] = {uid = 0, pID = PlayerInfo[src].uid, name = PlayerInfo[src].name, challengeID = k, dataPoint1 = 1, dataPoint2 = 0, dataPoint3 = 0}
            }
        end
        syncDatabaseUsers(sharedChallengeUsers[k][PlayerInfo[src].uid])
    end
    TriggerClientEvent('challange.SendChallengeUsersToClient', -1, sharedChallengeUsers)
end)