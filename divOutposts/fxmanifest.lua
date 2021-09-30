fx_version 'cerulean'
game 'gta5'

author 'CritteR / CritteRo'
description 'part of FiveReborn'

dependency 'divCore'
dependency 'blip_info'

client_scripts {
    'client/cl_outpost_main.lua',
    'client/cl_outpost_ui.lua',
}

server_scripts {
    'server/sv_outpost_main.lua',
    'server/sv_outpost_reward.lua',
}

shared_script 'shared/sh_outpost_main.lua'