fx_version 'cerulean'
games { 'gta5' }

lua54 'yes'

author 'Ju'
description 'a basic script about fivem natives'

version '1.0.1'

client_scripts {
    'client/**/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua'
}

server_scripts {
    'server/**/*.lua'
}

dependencies {
    'ox_lib',
    '/gameBuild:3095',
    '/server:7290'
}