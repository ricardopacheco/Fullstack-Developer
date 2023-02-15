# frozen_string_literal: true

module ProfileContext
  # This job is used to broadcast messages to current user profile when admin
  # deletes user.
  class DeleteUserBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_id)
      ActionCable.server.broadcast(
        'AdminContextChannel',
        build_delete_data('ADMIN_DELETE_USER', user_id)
      )
    end
  end
end
