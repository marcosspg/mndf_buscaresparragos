description '¡Busca espárragos y véndelos a cambio de diversión y dinero!'

version '1.0'
fx_version 'adamant'

game 'gta5'

shared_script '@es_extended/imports.lua'


client_scripts {
    'config.lua',
    '@es_extended/locale.lua',
    'locales/es.lua',
    'client/main.lua',
}


server_scripts {
    'config.lua',
    'server/main.lua',
}


files{
    'stream/esparrago.ydr',
    'stream/Esparrago.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/Esparrago.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/esparrago.ydr'


dependencies {
	'es_extended'
}

