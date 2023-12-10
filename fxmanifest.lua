fx_version 'cerulean'
game 'gta5'

author 'Alivemonstor'
description 'Cinematic Trader'
version '1.0.0'

client_scripts {
    'client.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
}
shared_script 'config.lua'
server_script 'server.lua'

ui_page 'html/index.html'

files {
    'html/*'
}

lua54 'yes'