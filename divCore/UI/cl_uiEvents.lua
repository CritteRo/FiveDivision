RegisterNetEvent("core.notify")
RegisterNetEvent("core.alert")
RegisterNetEvent("core.caption")
RegisterNetEvent("core.message")
RegisterNetEvent("core.banner")
RegisterNetEvent('core.changeTitle')

local showBanner = false

local titleSet = {
    title = "FiveDivision",
    activity = "~y~In Freeroam~s~",
}

--[[
function setRichPresence(title)
    local appID = --GetConvarInt(discordAppID, -1)
    if appID ~= nil and appID ~= -1 then
        print('discord')
        SetDiscordAppId(appID)
        SetDiscordRichPresenceAsset("lsl")
        SetDiscordRichPresenceAssetText("FiveM Server")
        SetRichPresence(title)
        SetDiscordRichPresenceAction(0, "CFX Account", "https://forum.cfx.re/u/critter/summary")
    end
end
]]
AddEventHandler("core.notify", function(_type, _notification)
    if _type == "simple" then
        notify(_notification.text, _notification.colID)
    elseif _type == "extended" then
        notifyex_ped(_notification.title,_notification.subtitle, _notification.icontype, _notification.text, _notification.colID)
    elseif _type == "suggestion" then
        notifyex(_notification.img, _notification.title, _notification.subtitle, tonumber(_notification.icontype), _notification.text, _notification.colID)
    elseif _type == "award" then
        AwardNotification(_notification.rp, _notification.text)
    elseif _type == "unlock" then
        notifyUnlock(_notification.title, _notification.text, _notification.icontype, _notification.colID)
    end
end)


AddEventHandler("core.alert", function(_alert)
    alert(_alert.text)
end)

AddEventHandler("core.caption", function(_caption)
    caption(_caption.text, _caption.ms)
end)

AddEventHandler("core.message", function(_message)
    TriggerEvent('chat:addMessage', {
        color = { _message.r, _message.g, _message.b},
        multiline = true,
        args = {_message.author, _message.text}
      })
end)

AddEventHandler("core.banner", function(_title, _subtitle, _waitTime, _playSound)
    local showBanner = true
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    end
    
    scale = ShowBanner(_title, _subtitle)
    Citizen.CreateThread(function()
        while showBanner do
            Citizen.Wait(0)
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
    Citizen.CreateThread(function()
        Citizen.Wait((tonumber(_waitTime) * 1000) - 400)
        BeginScaleformMovieMethod(scale, "SHARD_ANIM_OUT")
        PushScaleformMovieMethodParameterInt(2)
        PushScaleformMovieMethodParameterFloat(0.4)
        PushScaleformMovieMethodParameterInt(0)
        EndScaleformMovieMethod()
        Citizen.Wait(400)
        showBanner = false
    end)
end)

AddEventHandler('core.changeTitle', function(_title, _scoreboard)
    TriggerEvent("cS.ChangePauseMenuTitle", _title)
    if _scoreboard ~= nil then
        TriggerEvent('critPlayerList.ChangeTitle', _scoreboard)
    else
        TriggerEvent('critPlayerList.ChangeTitle', _title)
    end
    setRichPresence(_scoreboard.." | "..GetPlayerName(PlayerId()))
end)

function updateStatsUI(firstUpdate, xp, cash, bank)
    StatSetInt('MP0_WALLET_BALANCE', cash, true)
    StatSetInt('BANK_BALANCE', bank, true)
    StatSetInt('MPPLY_GLOBALXP', xp, true)
    UpdateXNLRankBar(firstUpdate, xp)
end

function UpdateXNLRankBar(firstUpdate, xp)
    local currentxp = tonumber(exports.XNLRankBar:Exp_XNL_GetCurrentPlayerXP())
    if firstUpdate == true then
        exports.XNLRankBar:Exp_XNL_SetInitialXPLevels(xp, true, false)
    elseif firstUpdate == false then
        if xp > currentxp then
            exports.XNLRankBar:Exp_XNL_AddPlayerXP(xp - currentxp)
        end
        if xp < currentxp then
            exports.XNLRankBar:Exp_XNL_RemovePlayerXP(currentxp - xp)
        end
        if xp == currentxp then
            exports.XNLRankBar:Exp_XNL_SetInitialXPLevels(xp, true, false)
        end
    end
end

function notifyAward(rp, string)
    Citizen.CreateThread(function()
        local handle = RegisterPedheadshot(PlayerPedId())
        while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
            Citizen.Wait(0)
        end
        local txd = GetPedheadshotTxdString(handle)
        -- Add the notification text, the more text you add the smaller the font
        -- size will become (text is forced on 1 line only), so keep this short!
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(string)
        -- Draw the notification
        EndTextCommandThefeedPostAward(txd, txd, rp, 0, "FM_GEN_UNLOCK")  
        -- Cleanup after yourself!
        UnregisterPedheadshot(handle)
    end)
end

function notifyUnlock(title, string, id, colID)
    if colID ~= nil then
        ThefeedSetNextPostBackgroundColor(colID)
    end
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(string)
    AddTextEntry('UNLOCK_TITLE_MSG', title)
    EndTextCommandThefeedPostUnlock("UNLOCK_TITLE_MSG", id, 0)
end

function notify(string, colID)
    if colID ~= nil then
        ThefeedSetNextPostBackgroundColor(colID)
    end
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(string)
    EndTextCommandThefeedPostTicker(true, true)
end

function caption(text, ms)
    BeginTextCommandPrint("string")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(ms, 1)
end

function alert(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayHelp(0,0,1,-1)
end

function notifyex_ped(_title,_subtitle, _icontype, _message, _colID)
    Citizen.CreateThread(function()
        -- Get the ped headshot image.
            local handle = RegisterPedheadshot(PlayerPedId())
            while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
                Citizen.Wait(0)
            end
            local txd = GetPedheadshotTxdString(handle)
        -- Add the notification text
        if _colID ~= nil then
            ThefeedSetNextPostBackgroundColor(_colID)
        end
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(_message)
    
        -- Set the notification icon, title and subtitle.
        local title = _title
        local subtitle = _subtitle
        local iconType = _icontype
        local flash = false -- Flash doesn't seem to work no matter what.
        EndTextCommandThefeedPostMessagetext(txd, txd, flash, iconType, title, subtitle)
    
        -- Draw the notification
        local showInBrief = true
        local blink = false -- blink doesn't work when using icon notifications.
        EndTextCommandThefeedPostTicker(blink, showInBrief)
        
        -- Cleanup after yourself!
        UnregisterPedheadshot(handle)
    end)
end

function chatMessage(_author, _message, _r, _g, _b)
    TriggerEvent('chat:addMessage', {
        color = { _r, _g, _b},
        multiline = true,
        args = {_author, _message}
      })
end

function notifyex(_img, _title, _subtitle, _icontype, _message, _colID)
    Citizen.CreateThread(function()
        -- Add the notification text
        if _colID ~= nil then
            ThefeedSetNextPostBackgroundColor(_colID)
        end
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(_message)
        EndTextCommandThefeedPostMessagetext(_img, _img, false, _icontype, _title, _subtitle)
        EndTextCommandThefeedPostTicker(true, true)
    end)
end

function ShowBanner(_text1, _text2)
    local scaleform = RequestScaleformMovie("mp_big_message_freemode")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_CENTERED_MP_MESSAGE")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SHARD_SET_TEXT")
    PushScaleformMovieMethodParameterString(_text1)
    PushScaleformMovieMethodParameterString(_text2)
    PushScaleformMovieMethodParameterInt(0)
    EndScaleformMovieMethod()
    return scaleform
end
