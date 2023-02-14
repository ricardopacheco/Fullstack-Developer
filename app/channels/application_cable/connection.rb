# frozen_string_literal: true

module ApplicationCable
  # Module ApplicationCable is a class that has a connection based on ActionCable
  # for websocket applications.
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user || reject_unauthorized_connection
    end

    protected

    def find_verified_user
      if (current_user = User.find_by(id: cookies.signed[:user_id]))
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
