# frozen_string_literal: true

module AdminContext
  # This job is used to broadcast messages to all admins when a admin create a user.
  class CreateUserBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_id)
      user = User.find(user_id)

      ActionCable.server.broadcast(
        'AdminContextChannel',
        build_message_data('ADMIN_CREATE_USER', user)
      )
    end
  end
end
