# frozen_string_literal: true

module AdminContext
  # This job is used to broadcast messages to all admins when a user is updated.
  class UpdateUserBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_id)
      user = User.find(user_id)

      ActionCable.server.broadcast(
        'AdminContextChannel',
        build_message_data('ADMIN_UPDATE_USER', user)
      )

      ActionCable.server.broadcast(
        "ProfileContextChannel-#{user.id}",
        build_message_data('ADMIN_UPDATE_YOUR_PROFILE', user)
      )
    end
  end
end
