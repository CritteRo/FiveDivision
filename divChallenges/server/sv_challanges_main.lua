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

RegisterNetEvent('challange.ProvideChallenges')
AddEventHandler('challange.ProvideChallenges', function()
    local src = source
    TriggerClientEvent('challange.SendChallengesToClient', src, sharedChallenges)
    Citizen.Wait(100)
    TriggerClientEvent('challange.SendChallengeUsersToClient', src, sharedChallengeUsers)
end)

AddEventHandler('onResourceStart', function(name)
    if name == GetCurrentResourceName() then
        TriggerEvent('core.RequestResourceUpdates')
        TriggerEvent('challange.RequestAllChallenges')
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
            sharedChallenges[k.uid] = k
            rows = rows + 1
        end
        print('Server loaded '..rows..' challenges.')
        TriggerClientEvent('challange.SendChallengesToClient', -1, sharedChallenges)
    end)
    exports.oxmysql:fetch("SELECT * FROM `challenge_users`",{},function (result)
        for i,k in pairs(result) do
            if sharedChallengeUsers[k.challengeID] ~= nil then
                sharedChallengeUsers[k.challengeID][k.pID] = k
            else
                sharedChallengeUsers[k.challengeID] = {
                    [k.pID] = k
                }
            end
        end
        print('Server loaded challenge users.')
        TriggerClientEvent('challange.SendChallengeUsersToClient', -1, sharedChallengeUsers)
    end)
end)

function syncDatabaseUsers(_data)
    local k = _data
    exports.oxmysql:update("UPDATE `challenge_users` SET `dataPoint1` = ?, `dataPoint2` = ?, `dataPoint3` = ? WHERE `pID` = ? and `challengeID` = ?",{k.dataPoint1, k.dataPoint2, k.dataPoint3, k.pID, k.challengeID}, function(affectedRows)
        if affectedRows == 0 then
            exports.oxmysql:update("INSERT INTO `challenge_users` (pID, name, challengeID, dataPoint1, dataPoint2, dataPoint3) VALUES (?,?,?,?,?,?)",{k.pID, k.name, k.challengeID, k.dataPoint1, k.dataPoint2, k.dataPoint3}, function(affectedRows)
                if affectedRows == 0 then
                    print('for some reason, syncDatabaseUsers() in sv_challanges_main could not update, nor insert a new user.')
                end
            end)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        for i, k in pairs(sharedChallenges) do
            if os.time() >= tonumber(k.missionEndUnix) and k.status == 'active' then
                k.status = "inactive"
                local _name = sharedChallangeTypeName[k.type]..string.format(sharedChallangeName[k.missionType][k.missionCondition1], k.missionCondition2)
                TriggerClientEvent('core.alert', -1, {text = '"~y~'.._name..'~s~" just expired.'})
                local _trans = {
                    {query = "DELETE FROM `challenges` WHERE `uid` = ?", values = {k.uid}},
                    {query = "DELETE FROM `challenge_users` WHERE `challengeID` = ?", values = {k.uid}}
                }
                exports.oxmysql:transaction(_trans, function(result) 
                end)
                sendChallengeRewardsToPlayers(k.uid)
                sharedChallenges[k.uid] = nil
                sharedChallengeUsers[k.uid] = nil
                TriggerClientEvent('challange.SendChallengesToClient', -1, sharedChallenges)
                TriggerClientEvent('challange.SendChallengeUsersToClient', -1, sharedChallengeUsers)
            end
        end
        TriggerClientEvent('challange.GetServerTime', -1, os.time())
        Citizen.Wait(10000)
    end
end)

RegisterCommand('getchal', function(source, args)
    TriggerClientEvent('challange.SendChallengesToClient', -1, sharedChallenges)
    Citizen.Wait(100)
    TriggerClientEvent('challange.SendChallengeUsersToClient', -1, sharedChallengeUsers)
end)

AddEventHandler('challenge.GenerateNewChallenge', function(_type, _mType, _mCondition1, _mCondition2, _mCondition3, _xp, _cash, _bank, _coins, _start)
    local src = source
    local canUseThis = false
    if tonumber(src) ~= nil and tonumber(src) >=1 then
        if PlayerInfo[src] ~= nil and PlayerInfo[src].admin >= 3 then
            canUseThis = true
        end
    else
        canUseThis = true
    end
    
    if canUseThis then
        local _temp = {
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
        if _temp.type == "weekly" then
            _temp.missionEndUnix = _temp.missionStartUnix + (86400 * 7)
        elseif _temp.type == "monthly" then
            _temp.missionEndUnix = _temp.missionStartUnix + (86400 * 30)
        end

        if os.time() >= _temp.missionStartUnix then
            _temp.status = "active"
        end
        local _k = _temp
        exports.oxmysql:fetch("INSERT INTO `challenges` (type, status, missionType, missionCondition1, missionCondition2, missionCondition3, missionRewardXP, missionRewardCash, missionRewardBank, missionRewardCoins, missionStartUnix, missionEndUnix) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            {_k.type, _k.status, _k.missionType, _k.missionCondition1, _k.missionCondition2, _k.missionCondition3, _k.missionRewardXP, _k.missionRewardCash, _k.missionRewardBank, _k.missionRewardCoins, _k.missionStartUnix, _k.missionEndUnix}, function(result)
                exports.oxmysql:fetch("SELECT * FROM `challenges` WHERE `missionStartUnix` = ? AND `missionEndUnix` = ?", {_k.missionStartUnix, _k.missionEndUnix}, function(_data)
                    for i, k in pairs(_data) do
                        sharedChallenges[k.uid] = k
                        print(k)
                    end
                    TriggerClientEvent('challange.SendChallengesToClient', -1, sharedChallenges)
                    local _name = sharedChallangeTypeName[_k.type]..string.format(sharedChallangeName[_k.missionType][_k.missionCondition1], _k.missionCondition2)
                    TriggerClientEvent('core.alert', -1, {text = '"~y~'.._name..'~s~" just started.'})
                end)
        end)
    end
end)

RegisterCommand('newchal', function(source, args)
    TriggerEvent('challenge.GenerateNewChallenge', 'weekly', 'outpost', 'liberate', 'any', '45', 5000, 2500, 10, 0, os.time() - 5)
end)

function sendChallengeRewardsToPlayers(_id)
    local _uids = {}
    print('rewarding players...')
    local challenge = sharedChallenges[_id]
    for i,k in pairs(sharedChallengeUsers[_id]) do --gathering all players that need to be rewarded in a single table
        if challenge.missionType == 'outpost' then
            if tonumber(k.dataPoint1) >= tonumber(challenge.missionCondition3) then
                table.insert(_uids, k.pID)
            end
        end
    end

    for _,id in ipairs(GetPlayers()) do --checking for online players first, so we can reward them through the normal channels.
        for i,k in pairs(_uids) do
            if PlayerInfo[tonumber(id)].uid == k then
                TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_challanges_main.lua', tonumber(id), "xp", 0, PlayerInfo[tonumber(id)].stats['xp'] + challenge.missionRewardXP, false, false)
                TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_challanges_main.lua', tonumber(id), "coins", 0, PlayerInfo[tonumber(id)].stats['coins'] + challenge.missionRewardCoins, false, false)
                TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_challanges_main.lua', tonumber(id), "bank", 0, PlayerInfo[tonumber(id)].stats['bank'] + challenge.missionRewardBank, false, false)
                TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_challanges_main.lua', tonumber(id), "cash", 0, PlayerInfo[tonumber(id)].stats['cash'] + challenge.missionRewardCash, true, true)
                _uids[i] = nil
            end
        end
    end

    local _trans = {}

    for i,k in pairs(_uids) do --update the stats for everyone who is not online.
        exports.oxmysql:fetch("SELECT `stats` FROM `users` WHERE `uid` = ?",{k},function (result)
            local _stats = json.decode(result[1].stats)
            _stats['xp'] =  _stats['xp'] + challenge.missionRewardXP
            _stats['coins'] =  _stats['coins'] + challenge.missionRewardCoins
            _stats['bank'] = _stats['bank'] + challenge.missionRewardBank
            _stats['cash'] = _stats['cash'] + challenge.missionRewardCash
            exports.oxmysql:fetch("UPDATE `users` SET `stats` = ? WHERE `uid` = ?",{json.encode(_stats), k},function (result)
                print('updated '..k)
            end)
        end)
    end
end