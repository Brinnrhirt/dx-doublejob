fx_version 'adamant'
game 'gta5'

server_scripts {
    'config.lua',
    '@es_extended/locale.lua',
    'locales/es.lua',
	'locales/en.lua',
    'server/main.lua',
    '@mysql-async/lib/MySQL.lua'
}

client_scripts {
    'config.lua',
    '@es_extended/locale.lua',
    'locales/es.lua',
	'locales/en.lua',
    'client/main.lua'
}