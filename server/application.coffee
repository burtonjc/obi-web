koa = require 'koa'
router = require('koa-router')()
logger = require 'koa-bunyan-logger'
bunyanLogentries = require 'bunyan-logentries'
passport = require 'koa-passport'

require('./passport').initialize()
require('./routes') router

app = koa()
app.keys = [process.env.OBI_WEB_SESSION_KEY ? 'ObiLovesTheWeb']
app
  .use require('koa-static')("#{__dirname}/../client/dist/")
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
  .use require('koa-generic-session')()
  .use passport.initialize()
  .use passport.session()
  .use router.routes()
  .use router.allowedMethods()

module.exports = app
