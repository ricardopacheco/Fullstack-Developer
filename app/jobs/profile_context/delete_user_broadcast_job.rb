# frozen_string_literal: true

module ProfileContext
  # This job is used to broadcast messages to current user profile when admin
  # deletes user.
  class DeleteUserBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_id)
      user = User.find(user_id)

      ActionCable.server.broadcast("ProfileContextChannel-#{user.id}", build_message_data)
    end

    private

    def build_message_data
      { type: 'DELETE_USER' }
    end
  end
end
