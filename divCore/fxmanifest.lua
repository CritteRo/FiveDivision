fx_version 'cerulean'
game 'gta5'

author 'CritteR / CritteRo'
description 'Core resource for FiveDivision'

--version 'vanilla_01'

--[[dependencies {
    'pma-voice',
    'scalePhone',
    'critScaleforms',
    'critLobby',
    'oxmysql',
}]]

client_scripts {
    'Player/cl_PlayerStats.lua',
    'World/cl_ambiance.lua',
}

server_scripts {
    'Connection/sv_login_register.lua',
    'Player/sv_PlayerStats.lua',
    'World/sv_ambiance.lua',
}

shared_script "Locales/sh_locales.lua"