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
    'critPlayerlist',
    'oxmysql',
    'XNLRankBar',
}]]

client_scripts {
    '@warmenu/warmenu.lua',
    'Player/cl_PlayerStats.lua',
    'Player/cl_PlayerCharacter.lua',
    'Player/cl_PlayerCharacter_menu.lua',
    'Player/cl_RespawnControl.lua',
    'Player/cl_PlayerArmory.lua',
    'CharacterCreation/cl_char_creation_menu.lua',
    'CharacterCreation/cl_char_creation.lua',
    'Commands/cl_admin_commands.lua',
    'World/cl_ambiance.lua',
    'World/cl_interiors.lua',
    'UI/cl_uiEvents.lua',
    'UI/cl_playerlist.lua',
    'UI/Phone/cl_phone_menu.lua',
    'UI/Phone/cl_phone_handle.lua',
}

server_scripts {
    'Connection/sv_login_register.lua',
    'Player/sv_PlayerStats.lua',
    'Player/sv_PlayerArmory.lua',
    'CharacterCreation/sv_char_creation.lua',
    'Commands/sv_admin_commands.lua',
    'UI/sv_playerlist.lua',
    'UI/Phone/sv_phone_handle.lua',
    'World/sv_ambiance.lua',
}

shared_script "Locales/sh_locales.lua"
shared_script "Player/sh_PlayerCharacter_allCosmetics.lua"
shared_script "Player/sh_PlayerArmory_allGuns.lua"