passport = require 'koa-passport'

module.exports = (router) ->
  router.post '/logout', (next) ->
    @logout()
    yield next
    @redirect '/'

  # GitHub OAuth
  router.post('/auth/github',
    passport.authenticate('github',
      scope: 'user,user:email,repo'))
  router.get('/auth/github/callback',
    passport.authenticate('github',
      successRedirect: '/'
      failureRedirect: '/login'))
