PlayerGroup = {
    --[0] = {leaderID = 0, members = {0}, inviteQueue = {0}, hudColor = 8, allCanInvite = false, name = "Player's Group"},
}

PlayerInviteQueue = {
    [0] = 0, --[source] = groupID
}


local nextGroupID = 1

local maxGroupMembers = 5 --including the leader

AddEventHandler('core.InviteToGroup', function(_player, _inviteMessage, _overrideSource)
    local src = source
    local player = tonumber(_player)
    if tonumber(_overrideSource) ~= nil and GetPlayerPing(tonumber(_overrideSource)) ~= 0 then
        src = tonumber(_overrideSource)
    end

    if PlayerInfo[src] ~= nil then
        if GetPlayerPing(player) ~= 0 and PlayerInfo[player] ~= nil then
            if PlayerInfo[player].group == 0 or not PlayerInviteQueue[player] ~= nil then
                local _groupID = PlayerInfo[src].group
                --if source is not in a group, create it!
                if PlayerInfo[src].group == 0 then
                    PlayerGroup[nextGroupID] = {leaderID = src, members = {src}, inviteQueue = {}, hudColor = 123, allCanInvite = false, name = "Group #"..nextGroupID..""}
                    PlayerInfo[player].group = nextGroupID
                    _groupID = nextGroupID
                    nextGroupID = nextGroupID + 1
                end
                --checks time!
                if PlayerGroup[_groupID] ~= nil and (PlayerGroup[_groupID].leaderID == src or PlayerGroup[_groupID].allCanInvite == true) then
                    local foundInvitee = false
                    local memberCount = 0
                    for i,k in pairs(PlayerGroup[_groupID].members) do
                        memberCount = memberCount + 1
                        if tonumber(k) == player then
                            foundInvitee = false
                        end
                    end
                    if foundInvitee == false then
                        if memberCount < maxGroupMembers then
                            PlayerInviteQueue[player] = _groupID
                            local _sms = {svID = src, contact = GetPlayerName(src), message = "You have been invite to join our group.\n\nInvitation message:\n<<"..tostring(_inviteMessage)..">>", isGroupInvite = true, groupID = _groupID}
                            TriggerClientEvent('phone.ReceiveMessage', src, _sms, false)
                            TriggerClientEvent('core.notify', src, "simple", {text = "Group invite sent to "..GetPlayerName(player).."!", colID = 123})
                            --UPDATE BOTH PLAYERS HERE
                        else
                            TriggerClientEvent('core.notify', src, "simple", {text = "Your group is full. Max members: "..maxGroupMembers..".", colID = 8})
                        end
                    else
                        TriggerClientEvent('core.notify', src, "simple", {text = "Player is already in the group.", colID = 8})
                    end
                else
                    TriggerClientEvent('core.notify', src, "simple", {text = "You cannot invite players to this group.", colID = 8})
                end
            else
                TriggerClientEvent('core.notify', src, "simple", {text = "Player is already in a group.", colID = 8})
            end
        else
            TriggerClientEvent('core.notify', src, "simple", {text = "Player is no longer online.", colID = 8})
        end
    end
end)