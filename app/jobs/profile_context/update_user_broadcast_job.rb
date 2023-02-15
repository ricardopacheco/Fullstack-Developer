# frozen_string_literal: true

module ProfileContext
  # This job is used to broadcast messages to inform admin when current profile
  # update his profile.
  class UpdateUserBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_id)
      user = User.find(user_id)

      ActionCable.server.broadcast(
        'AdminContextChannel',
        build_message_data('PROFILE_UPDATE_USER', user)
      )
    end
  end
end
