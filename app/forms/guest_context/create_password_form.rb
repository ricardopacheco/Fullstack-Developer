# frozen_string_literal: true

module GuestContext
  # Form class for create password. Receive data via html form and call operation.
  class CreatePasswordForm < ApplicationForm
    attr_reader :user
    attr_accessor :token, :password, :password_confirmation

    def self.model_name
      ActiveModel::Name.new(self, nil, 'User')
    end

    def submit
      GuestContext::CreatePasswordOperation.call(instance_values) do |result|
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
