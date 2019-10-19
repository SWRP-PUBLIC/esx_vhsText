files {
 'html/vhs.ttf',
 'html/main.js',
 'html/index.html',
}

ui_page 'html/index.html'

server_scripts {
  'server/main.lua',
  '@mysql-async/lib/MySQL.lua'
}

client_scripts {
  'config.lua',
  'client/main.lua'
}
