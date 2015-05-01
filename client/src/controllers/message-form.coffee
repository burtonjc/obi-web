angular.module('application').controller 'controllers.MessageForm', [
  '$scope'
  'services.Message'

  ($scope, Message) ->
    $scope.onSubmit = (message) ->
      return unless message
      Message.save {message}
      .$promise.then (response) ->
        console.log response
        $scope.response = response
]
