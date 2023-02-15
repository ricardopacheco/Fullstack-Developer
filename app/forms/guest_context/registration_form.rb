# frozen_string_literal: true

module GuestContext
  # Form class for register user profiles. Receive data via html form and call
  # operation.
  class RegistrationForm < ApplicationForm
    attr_reader :user
    attr_accessor :fullname, :email, :password, :password_confirmation, :avatar_image

    def self.model_name
      ActiveModel::Name.new(self, nil, 'User')
    end

    def submit
      ProfileContext::CreateProfileUserOperation.call(instance_values) do |result|
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
