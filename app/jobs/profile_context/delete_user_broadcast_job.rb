# frozen_string_literal: true

module ProfileContext
  # This job is used to broadcast messages to inform admin when a current profile
  # delete your account.
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
