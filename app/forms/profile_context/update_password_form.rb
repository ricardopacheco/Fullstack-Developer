# frozen_string_literal: true

module ProfileContext
  # Form class for user profile can update your current password profile.
  # Receive data via html form and call operation.
  class UpdatePasswordForm < ApplicationForm
    attr_reader :user
    attr_accessor :current_password, :password, :password_confirmation

    def self.model_name
      ActiveModel::Name.new(self, nil, 'User')
    end

    def submit(user_id)
      ProfileContext::UpdatePasswordOperation.call(user_id, instance_values) do |result|
        result.success do |user|
          @user = user

          true
        end
        result.failure do |failure|
          copy_error_messages(failure.to_h)

          false
        end
      end
    end
  end
end
