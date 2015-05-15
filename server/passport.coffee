passport = require 'koa-passport'

module.exports =
  initialize: ->
    passport.serializeUser (user, done) ->
      done null, user

    passport.deserializeUser (user, done) ->
      done null, user

    if process.env.NODE_ENV is 'production'
      baseUri = 'https://obi-web.herokuapp.com'
    else
      baseUri = "http://localhost:#{process.env.PORT}"

    GitHubStrategy = require('passport-github').Strategy
    passport.use new GitHubStrategy
      callbackURL: "#{baseUri}/auth/github/callback"
      clientID: process.env.OBI_GITHUB_CLIENT_ID
      clientSecret: process.env.OBI_GITHUB_CLIENT_SECRET
    ,
      (accessToken, refreshToken, profile, done) ->
        done null, profile
