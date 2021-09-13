RegisterNetEvent('critPlayerList:GetPlayers')

AddEventHandler('critPlayerList:GetPlayers', function()
    TriggerEvent('critPlayerList.ChangeTitle', "~b~FiveDivision~s~")
end)