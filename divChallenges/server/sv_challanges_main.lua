PlayerInfo = {
    [0] = {}
}

AddEventHandler('core.UpdateServerResources', function(_src, _info)
    if PlayerInfo[tonumber(_src)] ~= nil then
        PlayerInfo[tonumber(_src)].stats = _info.stats
        PlayerInfo[tonumber(_src)].group = _info.group
        PlayerInfo[tonumber(_src)].admin = _info.admin
        PlayerInfo[tonumber(_src)].activity = _info.activity
    else
        PlayerInfo[tonumber(_src)] = {
            name = _info.name,
            uid = _info.uid,
            stats = _info.stats,
            group = _info.group,
            admin = _info.admin,
            activity = _info.activity,
        }
    end
end)

AddEventHandler('onResourceStart', function(name)
    if name == GetCurrentResourceName() then
        TriggerEvent('core.RequestResourceUpdates')
        --load challanges here
    end
end)

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        --maybe do something? like saving the challanges, idk..
    end
end)

AddEventHandler('challange.RequestAllChallenges', function()
    sharedChallenges = {}
    sharedChallengeUsers = {}
    exports.oxmysql:fetch("SELECT * FROM `challenges`",{},function (result)
        local rows = 0
        for i,k in pairs(result) do
            sharedChallanges[k.uid] = k
            rows = rows + 1
        end
        print('Server loaded '..rows..' challenges.')
        TriggerClientEvent('challange.SendChallengesToClient', -1, sharedChallenges)
    end)
    exports.oxmysql:fetch("SELECT * FROM `challenge_users`",{},function (result)
        for i,k in pairs(result) do
            sharedChallenges[k.challengeID][k.pID] = k
        end
        print('Server loaded challenge users.')
        TriggerClientEvent('challange.SendChallengeUsersToClient', -1, sharedChallengeUsers)
    end)
end)

function syncDatabaseUsers(_data)
    for i,k in pairs(_data) do
        exports.oxmysql:execute("UPDATE `challenge_users` SET `dataPoint1` = ?, `dataPoint2` = ?, `dataPoint3` = ? WHERE `pID` = ? and `challengeID` = ?",{k.dataPoint1, k.dataPoint2, k.dataPoint3, uid, k.challengeID}, function(affectedRows)
            if affectedRows == 0 then
                exports.oxmysql:execute("INSERT INTO `challenge_users` (pID, name, challengeID, dataPoint1, dataPoint2, dataPoint3) VALUES (?,?,?,?,?,?)",{uid, k.name, k.challengeID, k.dataPoint1, k.dataPoint2, k.dataPoint3}, function(affectedRows)
                    if affectedRows == 0 then
                        print('for some reason, syncDatabaseUsers() in sv_challanges_main could not update, nor insert a new user.')
                    end
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        for i, k in pairs(sharedChallenges) do
            if k.missionStartUnix >= k.missionEndUnix and k.status == 'active' then
                k.status = "inactive"
                local _name = sharedChallangeTypeName[k.type]..string.format(sharedChallangeName[k.missionType][k.missionCondition1], "I")
                TriggerClientEvent('core.alert', -1, {text = '"~y~'.._name..'~s~" just expired.'})
            end
        end
        Citizen.Wait(10000)
    end
end)

AddEventHandler('challenge.GenerateNewChallenge', function(_type, _mType, _mCondition1, _mCondition2, _mCondition3, _xp, _cash, _bank, _coins, _start)
    local src = source
    local canUseThis = false
    if src >= 1 then
        if PlayerInfo[src] ~= nil and PlayerInfo[src].admin >= 3 then
            canUseThis = true
        end
    else
        canUseThis = true
    end
    
    if canUseThis then
        local _ids = {}
        local row = 1
        local maxId = 0
        for i,k in pairs(sharedChallenges) do
            _ids[row] = i
            if i > maxId then
                maxId = i
            end
            row = row + 1
        end
        sharedChallenges[maxId+1] = {
            uid = 0,
            type = _type, --daily, weekly, monthly..
            status = "inactive", --inactive or active
            missionType = _mType, --outpost, mission, kill, etc...
            missionCondition1 = _mCondition1, --for outpost: liberate or destroy.
            missionCondition2 = _mCondition2, --for outpost: 'any' or a factionID.
            missionCondition3 = _mCondition3, --for outpost: number of outposts that you need to achive.
            missionRewardXP = tonumber(_xp),
            missionRewardCash = tonumber(_cash),
            missionRewardBank = tonumber(_bank),
            missionRewardCoins = tonumber(_coins),
            missionStartUnix = tonumber(_start), --os.time(), unix 
            missionEndUnix = tonumber(_start) + 86400, --StartUnix + seconds, depending on "type"
        }
        if sharedChallenges[maxId+1].type == "weekly" then
            sharedChallenges[maxId+1].missionEndUnix = sharedChallenges[maxId+1].missionStartUnix + (86400 * 7)
        elseif sharedChallenges[maxId+1].type == "monthly" then
            sharedChallenges[maxId+1].missionEndUnix = sharedChallenges[maxId+1].missionStartUnix + (86400 * 30)
        end

        if os.time() >= sharedChallenges[maxId+1].missionStartUnix then
            sharedChallenges[maxId+1].status = "active"
        end
        TriggerClientEvent('challange.SendChallengesToClient', -1, sharedChallenges)
        local _k = sharedChallenges[maxId+1]
        exports.oxmysql:execute("INSERT INTO `challenges` (type, status, missionType, missionCondition1, missionCondition2, missionCondition3, missionRewardXP, missionRewardCash, missionRewardBank, missionRewardCoins, missionStartUnix, missionEndUnix) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            {_k.type, _k.status, _k.missionType, _k.missionCondition1, _k.missionCondition2, _k.missionCondition3, _k.missionRewardXP, _k.missionRewardCash, _k.missionRewardBank, _k.missionRewardCoins, _k.missionStartUnix, _k.missionEndUnix}, function(affectedRows)
            if affectedRows == 0 then
                print('for some reason, "challenge.GenerateNewChallenge" in sv_challanges_main could not insert a new challenge.')
            end
        end)
    end
end)