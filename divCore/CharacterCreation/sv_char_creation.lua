RegisterNetEvent('core.SavePlayerCharacter', function(ped)
    local src = source
    if PlayerInfo[src] ~= nil and PlayerInfo[src].stats ~= nil then
        if PlayerInfo[src].stats['charToken'] >= 1 then
           PlayerInfo[src].ped = ped
           PlayerInfo[src].stats['charToken'] = PlayerInfo[src].stats['charToken'] - 1
           updateClothesInDatabase(src, PlayerInfo[src].uid)
           TriggerClientEvent("core.CharacterCreationResponse", src, "passed", "")
        else
            TriggerClientEvent("core.CharacterCreationResponse", src, "notoken", "")
        end
    end
end)