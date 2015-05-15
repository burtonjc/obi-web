angular.module('application').config [
  '$locationProvider'
  '$stateProvider'
  '$urlRouterProvider'

  ($locationProvider, $stateProvider, $urlRouterProvider) ->
    $locationProvider.html5Mode(true).hashPrefix '!'

    $urlRouterProvider.rule ($injector, $location) ->
      newPath = S($location.path()).chompRight('/').s
      newPath if newPath isnt $location.path()

    $urlRouterProvider.otherwise '/'

    $stateProvider
    .state 'home',
      url: '/'
      templateUrl: '/partials/home.html'

    .state 'foo',
      url: '/foo'
      templateUrl: '/partials/foo.html'
]
