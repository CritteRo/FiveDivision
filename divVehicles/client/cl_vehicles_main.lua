myRoadCoords = {}

Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(PlayerPedId()) 
        local ret, _roadCoords, _heading = GetClosestVehicleNodeWithHeading(coords.x + math.random(-50, 50), coords.y + math.random(-50, 50), coords.z, 1, 3.0, 0)
        local retval, _sideCoords = GetPointOnRoadSide(_roadCoords.x, _roadCoords.y, _roadCoords.z)
        myRoadCoords = {roadCoords = _roadCoords, sideCoords = _sideCoords, heading = _heading}
        TriggerServerEvent('vehicles.UpdateMyCoords', myRoadCoords)
        Citizen.Wait(3000)
    end
end)