RegisterNetEvent('core.InviteToGroup')
RegisterNetEvent('core.ReplyToGroupInvite')
RegisterNetEvent('core.LeaveGroup')
RegisterNetEvent('core.TransferGroupLeader')

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
                    PlayerInfo[src].group = nextGroupID
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
                            TriggerClientEvent('core.notify', player, "simple", {text = GetPlayerName(src).." invited you to their group!", colID = 123})
                            local _sms = {svID = src, contact = GetPlayerName(src), message = "You have been invited to join group '"..PlayerGroup[_groupID].name.."'.\n\nInvitation message:\n".._inviteMessage.."", isGroupInvite = true, groupID = _groupID}
                            TriggerClientEvent('phone.ReceiveMessage', player, _sms, false)
                            TriggerClientEvent('core.notify', src, "simple", {text = "Group invite sent to "..GetPlayerName(player).."!", colID = 123})
                            --UPDATE BOTH PLAYERS HERE
                            TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src])
                            TriggerEvent('core.UpdateServerResources', src, PlayerInfo[src])
                            TriggerClientEvent('core.UpdateClientResources', player, PlayerInfo[player])
                            TriggerEvent('core.UpdateServerResources', player, PlayerInfo[player])
                            TriggerEvent('phone.sv.GatherContacts')
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

AddEventHandler('core.ReplyToGroupInvite', function(group, response)
    local src = source
    local _group = tonumber(group)
    if PlayerInfo[src] ~= nil and PlayerInfo[src].group == 0 then
        if PlayerInviteQueue[src] ~= nil and PlayerInviteQueue[src] == _group then
            if response == true then
                local memberCount = 0
                for i,k in pairs(PlayerGroup[_group].members) do
                    memberCount = memberCount + 1
                end
                if memberCount < maxGroupMembers then
                    for i,k in pairs(PlayerGroup[_group].members) do
                        TriggerClientEvent('core.notify', k, "simple", {text = "[~b~"..src.."~s~]~b~"..GetPlayerName(src).."~s~ joined the group!", colID = 2})
                    end
                    table.insert(PlayerGroup[_group].members, tonumber(src))
                    PlayerInviteQueue[src] = nil
                    PlayerInfo[src].group = _group
                    TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src])
                    TriggerEvent('core.UpdateServerResources', src, PlayerInfo[src])
                    TriggerEvent('phone.sv.GatherContacts')
                else
                    TriggerClientEvent('core.notify', src, "simple", {text = "Group is already full. Max members: "..maxGroupMembers..".", colID = 8})
                    TriggerClientEvent('core.notify', PlayerGroup[_group].leaderID, "simple", {text = "["..src.."]"..GetPlayerName(src).." tried to accept the group invite, but your group is full.", colID = 8})
                end
            elseif response == false then
                PlayerInviteQueue[src] = nil
                for i,k in pairs(PlayerGroup[_group].members) do
                    TriggerClientEvent('core.notify', k, "simple", {text = "["..src.."]"..GetPlayerName(src).." denied the group invitation!", colID = 8})
                end
                TriggerEvent('phone.sv.GatherContacts')
            else
                print('could not reply to group invite. invalid response.')
            end
            TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src])
            TriggerEvent('core.UpdateServerResources', src, PlayerInfo[src])
        else
            print('could not reply to group invite. Group invalid or disbanded.')
        end
    else
        print('could not reply to group invite. Player stats invalid or player already in a group.')
    end
end)

AddEventHandler('core.LeaveGroup', function(_overrideSource)
    local src = source
    print(src)
    if tonumber(_overrideSource) ~= nil and GetPlayerPing(tonumber(_overrideSource)) then
        src = tonumber(_overrideSource)
    end
    if PlayerInfo[src] ~= nil and PlayerInfo[src].group ~= 0 then
        local _group = PlayerInfo[src].group
        for i,k in pairs(PlayerGroup[_group].members) do
            if k == src then
                PlayerGroup[_group].members[i] = nil
                PlayerInfo[src].group = 0
                TriggerClientEvent('core.UpdateClientResources', src, PlayerInfo[src], false)
                TriggerEvent('core.UpdateServerResources', src, PlayerInfo[src])
                TriggerClientEvent('core.notify', k, "simple", {text = "You are no longer part of the group.", colID = 2})
            else
                TriggerClientEvent('core.notify', k, "simple", {text = "["..src.."]"..GetPlayerName(src).." left the group.", colID = 2})
            end
        end
        if PlayerGroup[_group].leaderID == src then --if you're the leader, pass it to someone else.
            local newMember = nil
            for i,k in pairs(PlayerGroup[_group].members) do
                newMember = k
            end
            if newMember ~= nil then -- if there is still someone in the group, make him/her lead
                PlayerGroup[_group].leaderID = newMember
                TriggerClientEvent('core.UpdateClientResources', newMember, PlayerInfo[newMember], false)
                TriggerEvent('core.UpdateServerResources', newMember, PlayerInfo[newMember])
                TriggerClientEvent('core.notify', newMember, "simple", {text = "You are now the group leader!", colID = 123})
            else --if not, disband the group.
            end
        end
        TriggerEvent('phone.sv.GatherContacts')
    else
        if GetPlayerPing(src) ~= 0 then
            TriggerClientEvent('core.notify', src, "simple", {text = "You are not part of a group.", colID = 8})
        end
    end
end)

AddEventHandler('core.TransferGroupLeader', function()
end)

RegisterCommand('gleave', function(source, args)
    local src = source
    TriggerEvent('core.LeaveGroup', src)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    TriggerEvent('core.LeaveGroup', src)
end)