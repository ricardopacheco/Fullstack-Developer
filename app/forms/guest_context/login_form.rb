# frozen_string_literal: true

module GuestContext
  # Form class for authentication. Receive data via html form and call operation.
  class LoginForm < ApplicationForm
    attr_reader :user
    attr_accessor :email, :password

    def self.model_name
      ActiveModel::Name.new(self, nil, 'User')
    end

    def submit
      GuestContext::AuthenticationOperation.call(instance_values) do |result|
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
