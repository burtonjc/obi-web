angular.module('application').controller 'controllers.MessageForm', [
  '$scope'
  'services.Message'

  ($scope, Message) ->
    $scope.onSubmit = (message) ->
      return unless message
      $scope.responses = Message.save {message}
]
