
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(false)
end)

spawns = {
    [1] = {model = "mp_m_freemode_01", x = 134.847, y = -765.327, z = 242.152, heading =  158.759, skipFade = false}, --FIB Safe zone interior
    [2] = {model = "mp_m_freemode_01", x = -93.934928894043, y = -851.32537841797, z = 40.573017120361, heading =  111.495231, skipFade = false}, --Maze Bank Stairs
}

firstJoiners = {
    [1] = {model = "mp_m_freemode_01", x = 421.385, y = -807.777, z = 29.491, heading =  81.291, skipFade = false, actionData = {task = "walkToCoord", x = 415.058, y = -807.601, z = 29.346, h = 91.21}},
    [2] = {model = "mp_m_freemode_01", x = -816.166, y = -1081.949, z = 11.12, heading =  28.375, skipFade = false, actionData = {task = "walkToCoord", x = -819.282, y = -1074.723, z = 11.32, h = 32.233}},
    [3] = {model = "mp_m_freemode_01", x = 315.579, y = -275.14, z = 53.92, heading =  160.59, skipFade = false, actionData = {task = "walkToCoord", x = 308.084, y = -280.64, z = 54.16, h = 158.87}},
}

RegisterNetEvent("core.respawn")
AddEventHandler("core.respawn", function(firstSpawn, _overrideSpawnPoint)
    if not firstSpawn then
        DoScreenFadeOut(2000)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        exports.spawnmanager:forceRespawn()
        if _overrideSpawnPoint ~= nil and type(_overrideSpawnPoint) == "table" then
            exports.spawnmanager:spawnPlayer(_overrideSpawnPoint)
        else
            exports.spawnmanager:spawnPlayer(spawns[math.random(1, #spawns)])
        end
        PlayerData.respawnTask = nil
        ClearTimecycleModifier()
        DoScreenFadeIn(1000)
        Citizen.Wait(1000)
    else
        local _id = math.random(1, #firstJoiners)
        DoScreenFadeOut(1)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        exports.spawnmanager:forceRespawn()
        exports.spawnmanager:spawnPlayer(firstJoiners[_id])
        PlayerData.respawnTask = firstJoiners[_id].actionData
        ClearTimecycleModifier()
        DoScreenFadeIn(1000)
        Citizen.Wait(1000)
        local hour = GetClockHours()
        local minute = GetClockMinutes()
        if tonumber(hour) < 10 then
            hour = "0"..hour
        end
        if tonumber(minute) < 10 then
            minute = "0"..minute
        end
        TriggerEvent('cS.MidsizeBanner', "FiveDivision", "Game time: "..hour..":"..minute.."\n", 123, 12, true)
    end
    TriggerEvent('weather.SetSnowWeather', 1)
end)

RegisterNetEvent("core.StartRespawnMenu")
AddEventHandler('core.StartRespawnMenu', function(_type, _deathStats)
    --_type should be "overworld", "mission" or "pvp".
    SetTimecycleModifier("dying")
    PlaySoundFrontend(-1, "Bed", "WastedSounds", false)
    Citizen.Wait(3000)
    local waitForResponse = true
    while waitForResponse do
        DisplayHudWhenDeadThisFrame()
        caption('Show some death stats here...', 10)
        if _type == "overworld" then --OPEN WORLD SPAWN
            alert("~INPUT_CONTEXT~ Spawn Nearby\n~INPUT_CONTEXT_SECONDARY~ Spawn at nearest hideout") --51 and 52
            if IsControlJustReleased(0,  51) then
                local ped = PlayerPedId()
                local deathCoords = GetEntityCoords(ped)
                local ret, coordsTemp, _heading = GetClosestVehicleNodeWithHeading(deathCoords.x + (math.random(100,250) * int[math.random(1,2)]), deathCoords.y + (math.random(100,250) * int[math.random(1,2)]), deathCoords.z, 1, 3.0, 0)
                local newCoords = {model = "mp_m_freemode_01", x = coordsTemp.x, y = coordsTemp.y, z = coordsTemp.z, heading = _heading, skipFade = false}
                TriggerEvent('core.respawn', false, newCoords)
                waitForResponse = false
            elseif IsControlJustReleased(0,  52) then
                TriggerEvent('core.respawn', false)
                waitForResponse = false
            end
        elseif _type == "mission" then
            alert("~INPUT_CONTEXT~ Spawn at nearest checkpoint\n~INPUT_CONTEXT_SECONDARY~ Spawn at mission start")
            if IsControlJustReleased(0,  51) then
                -- run code here
            elseif IsControlJustReleased(0,  52) then
                -- run code here
            end
        elseif _type == "pvp" then
            alert("~INPUT_CONTEXT~ Spawn at nearest hideout.")
            if IsControlJustReleased(0,  51) then
                -- run code here
            end
        else
            TriggerEvent('core.respawn', false)
            waitForResponse = false
        end
        Citizen.Wait(0)
    end
end)

int = {
    [1] = 1,
    [2] = -1,
}

RegisterCommand('respawn', function(source, args)
    if args[1] ~= nil then
        TriggerEvent('core.respawn', true)
    else
        SetEntityHealth(PlayerPedId(), 0)
    end
end)