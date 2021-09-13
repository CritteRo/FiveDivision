
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(false)
    exports.spawnmanager:forceRespawn()
    exports.spawnmanager:spawnPlayer(spawns[1])
end)

spawns = {
    [1] = {model = "mp_m_freemode_01", x = 134.847, y = -765.327, z = 242.152, heading =  158.759, skipFade = false}, --FIB Safe zone interior
    [2] = {model = "mp_m_freemode_01", x = -93.934928894043, y = -851.32537841797, z = 40.573017120361, heading =  111.495231, skipFade = false}, --Maze Bank Stairs
}

RegisterNetEvent("core.respawn")
AddEventHandler("core.respawn", function(firstSpawn)
    Citizen.CreateThread(function()
        if not firstSpawn then
            SetTimecycleModifier("dying")
            PlaySoundFrontend(-1, "Bed", "WastedSounds", false)
            Citizen.Wait(3000)
            DoScreenFadeOut(2000)
            while not IsScreenFadedOut() do
                Citizen.Wait(100)
            end
        else
            DoScreenFadeOut(1)
            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
        end
        exports.spawnmanager:forceRespawn()
        exports.spawnmanager:spawnPlayer(spawns[1])
        ClearTimecycleModifier()
        DoScreenFadeIn(1000)
        Citizen.Wait(1000)
        TriggerEvent('weather.SetSnowWeather', 1)
    end)
end)

RegisterCommand('respawn', function()
    SetEntityHealth(PlayerPedId(), 0)
end)