PlayerInfo = {
    [0] = {
        name = "console",
        uid = 0,
        stats = {},
        admin = 0,
    }
}

ambientCars = {
    "mesa2", "asea2", "sadler2", "burrito5", "rancherxl2", "emperor3",
}

--[[
    CARS:
    - mesa2
    - asea2
    - sadler2
    - burrito5
    - rancherxl2
    - emperor3
    - stockade3
    - policeold1
    - policeold2
]]

AddEventHandler('core.UpdateServerResources', function(_src, _info)
    if PlayerInfo[tonumber(_src)] ~= nil then
        PlayerInfo[tonumber(_src)].stats = _info.stats
        PlayerInfo[tonumber(_src)].admin = _info.admin
    else
        PlayerInfo[tonumber(_src)] = {
            name = _info.name,
            uid = _info.uid,
            stats = _info.stats,
            admin = _info.admin,
            coords = {}
        }
    end
end)

RegisterNetEvent('vehicles.UpdateMyCoords')
AddEventHandler('vehicles.UpdateMyCoords', function(_coords)
    local src = source
    if _coords.roadCoords ~= nil and _coords.sideCoords ~= nil and _coords.heading ~= nil then
        if _coords.roadCoords.x ~= nil and _coords.sideCoords.x ~= nil then
            PlayerInfo[src].coords = _coords
        else
            print('nil in coords for client ID '..src)
        end
    else
        print('nil in road group for client ID '..src)
    end
end)

AddEventHandler('onResourceStart', function(name)
    if name == GetCurrentResourceName() then
        TriggerEvent('core.RequestResourceUpdates')
    end
end)

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        for i,k in pairs(vehicleDump) do
            if DoesEntityExist(k) then
                DeleteEntity(k)
            end
        end
    end
end)

RegisterCommand('car', function(source, args)
    local src = source
    if PlayerInfo[src] ~= nil and PlayerInfo[src].admin >= 2 then
        local coords = GetEntityCoords(GetPlayerPed(src))
        local carModel = ambientCars[math.random(1, #ambientCars)]
        if args[1] ~= nil and type(args[1]) == "string" then
            carModel = args[1]
        end
        spawnVehicle(carModel, coords.x+2, coords.y, coords.z, 0.0, 0, 0, true, true)
    end
end)