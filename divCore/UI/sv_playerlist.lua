AddEventHandler('core.GatherPlayersForScoreboard', function()
    local players_2 = {}
    local slotid_2 = 0

    for _,player in ipairs(GetPlayers()) do
        local src = tonumber(player)
        if PlayerInfo[src] ~= nil then
            local _crew = adminRankToCrew[tonumber(PlayerInfo[src].admin)]
            local _jp = tonumber(PlayerInfo[src].group)
            players_2[slotid_2] = {name = GetPlayerName(src), id = src, crew = _crew, rightText = "", rank = tostring(PlayerInfo[src].stats['level']), showJP = false, txd = 'CHAR_BLANK_ENTRY'}
            slotid_2 = slotid_2 + 1
        end
    end

    TriggerClientEvent('critPlayerList:GetPlayers', -1, players_2)
end)

adminRankToCrew = {
    [0] = "",
    [1] = "",
    [2] = "",
    [3] = "MOD",
    [4] = "ADMIN",
}