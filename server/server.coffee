require 'colors'

process.env.PORT ?=  4000

application = require './application'

server = application.listen process.env.PORT, ->
  host = server.address().address
  host = 'localhost' if host is '::'
  port = server.address().port
  console.log "Application running at: #{host}:#{port}".grey
