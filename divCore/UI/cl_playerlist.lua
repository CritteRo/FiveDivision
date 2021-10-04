RegisterNetEvent('critPlayerList:GetPlayers')

AddEventHandler('critPlayerList:GetPlayers', function()
    TriggerEvent('critPlayerList.ChangeTitle', "~b~FiveDivision~s~")
end)

RegisterNetEvent('core.SendScoreboardToClients')
AddEventHandler('core.SendScoreboardToClients', function(players)
    local _players = players
    for i,k in pairs(_players) do
        if k.group ~= 0 and k.group == PlayerInfo.group then
            _players[i].color = k.groupColor
        end
    end
    TriggerEvent('critPlayerList:GetPlayers', _players)
end)