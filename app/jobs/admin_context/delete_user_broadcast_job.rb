# frozen_string_literal: true

module AdminContext
  # This job is used to broadcast messages to all admins when a admin delete a user.
  class DeleteUserBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_id)
      ActionCable.server.broadcast(
        'AdminContextChannel',
        build_delete_data('ADMIN_DELETE_USER', user_id)
      )

      ActionCable.server.broadcast(
        "ProfileContextChannel-#{user_id}",
        build_delete_data('ADMIN_DELETE_YOUR_PROFILE', user_id)
      )
    end
  end
end
