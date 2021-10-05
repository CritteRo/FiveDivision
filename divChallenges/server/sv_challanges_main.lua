PlayerInfo = {
    [0] = {}
}

AddEventHandler('core.UpdateServerResources', function(_src, _info)
    if PlayerInfo[tonumber(_src)] ~= nil then
        PlayerInfo[tonumber(_src)].stats = _info.stats
        PlayerInfo[tonumber(_src)].group = _info.group
    else
        PlayerInfo[tonumber(_src)] = {
            name = _info.name,
            uid = _info.uid,
            stats = _info.stats,
            group = _info.group,
            
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