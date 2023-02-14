# frozen_string_literal: true

module AdminContext
  # This job is used to broadcast messages to all admins when a new user is
  # created.
  class CreateUserBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_id)
      user = User.find(user_id)

      ActionCable.server.broadcast('AdminContextChannel', build_message_data(user))
    end

    private

    def build_message_data(user)
      {
        type: 'CRATE_USER',
        payload: user.slice(:id, :email, :fullname, :role)
      }
    end
  end
end
