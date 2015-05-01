process.env.PORT ?=  4000

require 'colors'
koa = require 'koa'
router = require('koa-router')()
logger = require 'koa-bunyan-logger'
bunyanLogentries = require 'bunyan-logentries'

router.get '/', (next) ->
  @body = yield @render 'index'

app = koa()

app
  .use require('koa-static')("#{__dirname}/../client/dist/js")
  .use require('koa-static')("#{__dirname}/../client/dist/partials")
  .use require('koa-static')("#{__dirname}/../client/dist/css")
  .use logger
    name: 'obi-server'
    level: process.env.LOG_LEVEL || 'debug'
    streams: [
      level: 'info'
      stream: bunyanLogentries.createStream token: process.env.OBI_LOGENTRIES_TOKEN
      type: 'raw'
    ,
      level: 'info',
      stream: process.stdout
    ]
  .use logger.requestIdContext()
  .use logger.timeContext()
  .use logger.requestLogger()
  .use require('koa-bodyparser')()
  .use require('koa-render')("#{__dirname}/views", 'jade')
  .use router.routes()
  .use router.allowedMethods()

server = app.listen process.env.PORT, ->
  host = server.address().address
  host = 'localhost' if host is '::'
  port = server.address().port
  console.log "Application running at: #{host}:#{port}".grey
