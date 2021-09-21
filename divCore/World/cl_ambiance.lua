AddEventHandler('weather.SetSnowWeather', function(overrideTime)
    if overrideTime ~= nil then
        Citizen.Wait(overrideTime)
    else
        Citizen.Wait(5000)
    end
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist("XMAS") --XMAS
    SetWeatherTypeNow("XMAS")
    SetWeatherTypeNowPersist("XMAS")
    SetForceVehicleTrails(true)
    SetForcePedFootstepsTracks(true)
    SetFlashLightKeepOnWhileMoving(true)
    SetArtificialLightsState(true) --blackout
    SetArtificialLightsStateAffectsVehicles(false) --but don't affect vehicles
end)
TriggerEvent('weather.SetSnowWeather')