vehicleDump = {} --entity dumpster

refreshTime = 60--in seconds

function MarkServerEntityAsNoLongerNeeded(_entity) --the function
	if DoesEntityExist(_entity) then --check if entity exists
		if NetworkGetEntityOwner(_entity) ~= -1 then --can anyone see the entity?
			table.insert(vehicleDump, _entity) --if yes, store for later.
		else
			DeleteEntity(_entity) --if no, just delete it.
		end
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(refreshTime * 1000) --arbitrary number of ms...
        runVehicleCleanup()
        for _, id in ipairs(GetPlayers()) do
            local src = tonumber(id)
            local rand = math.random(1,2)
            if PlayerInfo[src] ~= nil and PlayerInfo[src].coords ~= nil then
                local roadCoords = PlayerInfo[src].coords.roadCoords
                local sideCoords = PlayerInfo[src].coords.sideCoords
                local _heading = PlayerInfo[src].coords.heading
                if rand == 1 then
                    spawnVehicle(ambientCars[math.random(1, #ambientCars)], roadCoords.x, roadCoords.y, roadCoords.z, _heading, 0, 0, true, true)
                else
                    spawnVehicle(ambientCars[math.random(1, #ambientCars)], sideCoords.x, sideCoords.y, sideCoords.z, _heading, 0, 0, true, true)
                end
            else
                print('player '..src.."doesn't have the correct coords..")
            end
        end
    end
end)

function spawnVehicle(_model, _x, _y, _z, _h, _col1, _col2, _alarm, _isAmbient)
    local carId = CreateVehicle(_model, _x, _y, _z, _h, true, false)
    SetVehicleAlarm(carId, _alarm)
    SetVehicleColours(carId, _col1, _col2)
    while not DoesEntityExist(carId) do
        Citizen.Wait(0)
    end
    if _isAmbient == true then
        MarkServerEntityAsNoLongerNeeded(carId)
    end
    return carId
end

function runVehicleCleanup()
    for i,k in pairs(vehicleDump) do --check the dumpster
        if NetworkGetEntityOwner(k) == -1 then --can anyone see the entity?
            DeleteEntity(k) --if no, delete it.
            vehicleDump[i] = nil --clean it.
        end
    end
end