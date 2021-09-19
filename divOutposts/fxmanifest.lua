fx_version 'cerulean'
game 'gta5'

author 'CritteR / CritteRo'
description 'part of FiveReborn'

dependency 'divCore'

client_scripts {
    'client/cl_outpost_main.lua',
    'client/cl_outpost_ui.lua',
}

server_scripts {
    'server/sv_outpost_main.lua',
}

shared_script 'shared/sh_outpost_main.lua'