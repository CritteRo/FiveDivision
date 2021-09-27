
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
AddEventHandler("core.respawn", function(firstSpawn)
    if not firstSpawn then
        SetTimecycleModifier("dying")
        PlaySoundFrontend(-1, "Bed", "WastedSounds", false)
        Citizen.Wait(3000)
        DoScreenFadeOut(2000)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        exports.spawnmanager:forceRespawn()
        exports.spawnmanager:spawnPlayer(spawns[1])
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

RegisterCommand('respawn', function(source, args)
    if args[1] ~= nil then
        TriggerEvent('core.respawn', true)
    else
        SetEntityHealth(PlayerPedId(), 0)
    end
end)