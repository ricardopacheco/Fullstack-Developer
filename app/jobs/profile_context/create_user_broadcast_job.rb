# frozen_string_literal: true

module ProfileContext
  # This job is used to broadcast messages to inform admin when a new profile is
  # registered.
  class CreateUserBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_id)
      user = User.find(user_id)

      ActionCable.server.broadcast(
        'AdminContextChannel',
        build_message_data('PROFILE_CREATE_USER', user)
      )
    end
  end
end
