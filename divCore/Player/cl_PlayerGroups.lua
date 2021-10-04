groupBlips = {}
groupMembers = {}

RegisterNetEvent('core.UpdateGroupBlips')

AddEventHandler('core.UpdateGroupBlips', function(members)
    groupMembers = members
    for i,k in pairs(groupBlips) do
        RemoveBlip(k)
    end
    local row = 1
    AddTextEntry("BLIP_OTHPLYR", "Group Members")
    for i,k in pairs(groupMembers) do
        if DoesEntityExist(NetToPed(k.entity)) then
            groupBlips[row] = createEntityBlip(k.name, 1, NetToPed(k.entity), 123, 0.6)
            SetBlipCategory(groupBlips[row], 7)
            ShowCrewIndicatorOnBlip(groupBlips[row], true)
            SetBlipSecondaryColour(groupBlips[row], 0, 200, 0)
        else
            groupBlips[row] = createStaticBlip(k.name, 1, k.x, k.y, k.z, 85, 0.6)
            SetBlipCategory(groupBlips[row], 7)
            ShowCrewIndicatorOnBlip(groupBlips[row], true)
            SetBlipSecondaryColour(groupBlips[row], 0, 200, 0)
        end
        row = row + 1
    end
end)

function createStaticBlip(name, blip, x, y, z, color, size)
    _blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(_blip, blip)
    SetBlipDisplay(_blip, 4)
    SetBlipScale(_blip, size+0.0)
    SetBlipColour(_blip, color)
    SetBlipAsShortRange(_blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(_blip)

    return _blip
end

function createEntityBlip(name, blip, entity, color, size)
    local id = AddBlipForEntity(entity)
    SetBlipSprite(id, blip)
    SetBlipDisplay(id, 4)
    SetBlipColour(id, color)
    SetBlipScale(id, size+0.0001)
    SetBlipAsShortRange(id, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(id)

    return id
end