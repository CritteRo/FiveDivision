fx_version 'cerulean'
game 'gta5'

client_scripts {
    'client/cl_challanges_menu.lua',
    'client/cl_challanges_main.lua',
}

server_scripts {
    'server/sv_challanges_db.lua',
    'server/sv_challanges_gatherers.lua',
    'server/sv_challanges_main.lua',
}

shared_script 'shared/sh_challanges_main.lua'