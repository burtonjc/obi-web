module.exports = (router) ->

  router.get '/', (next) ->

    if @passport.user
      @body = yield @render 'application/index'
    else
      @body = yield @render 'marketing/index'
