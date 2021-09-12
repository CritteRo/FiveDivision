fx_version 'cerulean'
game 'gta5'

author 'CritteR / CritteRo'
description 'Core resource for FiveDivision. https://forum.cfx.re/u/critter/summary'

--version 'vanilla_01'

--[[dependencies {
    'pma-voice',
    'scalePhone',
    'critScaleforms',
    'critLobby',
    'oxmysql',
    'XNLRankBar',
}]]

client_scripts {
    'Player/cl_PlayerStats.lua',
    'Player/cl_PlayerCharacter.lua',
    'Player/cl_RespawnControl.lua',
    'World/cl_ambiance.lua',
    'UI/cl_uiEvents.lua',
}

server_scripts {
    'Connection/sv_login_register.lua',
    'Player/sv_PlayerStats.lua',
    'World/sv_ambiance.lua',
}

shared_script "Locales/sh_locales.lua"
shared_script "Player/sh_PlayerCharacter_allCosmetics.lua"