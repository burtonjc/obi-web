angular.module('application').factory 'services.Message', [
  '$resource'

  ($resource) ->
    $resource "http://localhost:4001/messages"
]
