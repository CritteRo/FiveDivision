SetRoutingBucketPopulationEnabled(0, false)
SetRoutingBucketEntityLockdownMode(0, "strict")

--WEATHER--
serverWorldTimeSettings = {
	time = "gtao",
	h = 5,
	m = 0,
	s = 0
}

serverWeather = "CLEAR"
serverBo = false

AddEventHandler("onServerResourceStart", function(resName)
	if resName == "divCore" then
		Wait(500)
        local weatherTime = 0
		while true do
            Wait(1800)
            weatherTime = weatherTime + 1
			local servertime = handleTime(serverWorldTimeSettings)
			TriggerClientEvent("core.ChangeTime", -1, servertime)
            if weatherTime >= 100 then
                local setClientWeather = {
                    weatherType = serverWeather
                }
                TriggerClientEvent("core.ChangeWeather", -1, setClientWeather)
                TriggerClientEvent("core.SetBlackout", -1, serverBo)
            end
		end
	end
end)

blacko = false

RegisterCommand("setdate", function(source, args)
	local src = source
	if PlayerInfo[src].admin >= 2 then
		if args[1] ~= nil then
			if args[1] == "real" then
				serverWorldTimeSettings.time = "real"
			elseif args[1] == "gtao" then
				serverWorldTimeSettings.time = "gtao"
			elseif args[1] == "fixed" then
				serverWorldTimeSettings.time = "fixed"
				if args[4] ~= nil then
					serverWorldTimeSettings.h = tonumber(args[2])
					serverWorldTimeSettings.m = tonumber(args[3])
					serverWorldTimeSettings.s = tonumber(args[4])
				else
					serverWorldTimeSettings.h = 19
					serverWorldTimeSettings.m = 0
					serverWorldTimeSettings.s = 0
				end
			else
				local _notif = {
					text = "Choose between ~y~real~s~, ~y~gtao~s~ or ~y~fixed~s~.",
                    colID = 8,
				}
				TriggerClientEvent("core.notify", src, "simple", _notif)
			end
		end
	else
		local _notif = {
			text = "Wrong Rank! [PLACEHOLDER]",
            colID = 8,
		}
		TriggerClientEvent("core.notify", src, "simple", _notif)
	end
end)

RegisterCommand('setblackout', function(source, args)
    local src = source
    if PlayerInfo[src].admin >= 2 then
        if args[1] == "true" then
            serverBo = true
            TriggerClientEvent("core.SetBlackout", -1, serverBo)
        elseif args[1] == "false" then
            serverBo = false
            TriggerClientEvent("core.SetBlackout", -1, serverBo)
        end

    end
end)

RegisterCommand("setweather", function(source, args)
	local src = source
	if PlayerInfo[src].admin >= 2 then
		if args[1] ~= nil then
			if args[1] == "clear" then
				local servertime = {
					weatherType = "CLEAR"
				}
                TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
			elseif args[1] == "rain" then
				local servertime = {
					weatherType = "RAIN"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
            elseif args[1] == "sunny" then
				local servertime = {
					weatherType = "EXTRASUNNY"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
			elseif args[1] == "clouds" then
				local servertime = {
					weatherType = "OVERCAST"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
            elseif args[1] == "thunder" then
				local servertime = {
					weatherType = "THUNDER"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
            elseif args[1] == "smog" then
				local servertime = {
					weatherType = "SMOG"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
            elseif args[1] == "foggy" then
				local servertime = {
					weatherType = "FOGGY"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
            elseif args[1] == "blizzard" then
				local servertime = {
					weatherType = "BLIZZARD"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
            elseif args[1] == "xmas" then
				local servertime = {
					weatherType = "XMAS"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
            elseif args[1] == "snow" then
				local servertime = {
					weatherType = "SNOW"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
            elseif args[1] == "snowlight" then
				local servertime = {
					weatherType = "SNOWLIGHT"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
			else
				local servertime = {
					weatherType = "CLEARING"
				}
				TriggerClientEvent("core.ChangeWeather", -1, servertime)
                serverWeather = servertime.weatherType
			end
		else
			local servertime = {
				weatherType = "CLEAR"
			}
			TriggerClientEvent("core.ChangeWeather", -1, servertime)
            serverWeather = servertime.weatherType
		end
	else
		local _notif = {
			text = "Wrong Rank! [PLACEHOLDER]",
            colID = 8,
		}
		TriggerClientEvent("core.notify", src, "simple", _notif)
	end
end)

function handleTime(_data)
	local _time = {h = 0, m = 0, s = 0}
	if _data.time == "real" then
		_time = {
			h = tonumber(os.date("%H")),
			m = tonumber(os.date("%M")),
			s = tonumber(os.date("%S")),
		}
	elseif _data.time == "gtao" then
		--normal gta time. 1 ingame minute = 1 real second
		_time = {
			h = _data.h,
			m = _data.m,
			s = _data.s,
		}
	else
		_time = {
			h = _data.h,
			m = _data.m, --fixed time.
			s = _data.s,
		}
	end
	return _time
end

Citizen.CreateThread(function()
	while true do
		if serverWorldTimeSettings.time == "gtao" then
			if serverWorldTimeSettings.m == 59 then
				serverWorldTimeSettings.m = 0
				serverWorldTimeSettings.h = serverWorldTimeSettings.h + 1
			else
				serverWorldTimeSettings.m = serverWorldTimeSettings.m + 1
			end
			if serverWorldTimeSettings.h == 24 then
				serverWorldTimeSettings.h = 0
			end
		end
		Citizen.Wait(1800)
	end
end)
