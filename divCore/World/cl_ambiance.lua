RegisterNetEvent("core.ChangeTime")
RegisterNetEvent("core.ChangeWeather")
RegisterNetEvent("core.SetBlackout")

servertime = {h = 0, m = 0, s = 0}
local CurrentWeather = "CLEAR"
local lastWeather = CurrentWeather
local blackOut = false
ForceSnowPass(true)

Citizen.CreateThread(function()
	Citizen.Wait(250)
	while true do
		Citizen.Wait(100)
		NetworkOverrideClockTime(servertime.h, servertime.m, servertime.s, false)
    end
end)

AddEventHandler("core.ChangeTime", function(_servertime)
    servertime = _servertime
end)

AddEventHandler("core.ChangeWeather", function(_servertime)
    CurrentWeather = _servertime.weatherType
end)

AddEventHandler("core.SetBlackout", function(_bo)
    blackOut = _bo
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        SetForceVehicleTrails(true)
        ForceSnowPass(true)
        SetForcePedFootstepsTracks(true)
        SetFlashLightKeepOnWhileMoving(true)
        SetArtificialLightsState(blackOut) --blackout
        SetArtificialLightsStateAffectsVehicles(false) --but don't affect vehicles
    end
end)

RegisterCommand("_snow", function(source, args)
    SetSnowLevel(tonumber(args[1]))
end)