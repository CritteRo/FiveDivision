fx_version 'cerulean'
game 'gta5'

client_scripts {
    'client/cl_defend_menu.lua',
    'client/cl_defend_main.lua',
}

server_scripts {
    'server/sv_defend_main.lua',
}

shared_script 'shared/sh_defend_main.lua'

dependency 'divCore'