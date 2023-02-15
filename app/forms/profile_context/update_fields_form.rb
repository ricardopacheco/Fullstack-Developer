# frozen_string_literal: true

module ProfileContext
  # Form class for user update your profile. Receive data via html form and call
  # operation.
  class UpdateFieldsForm < ApplicationForm
    attr_reader :user
    attr_accessor :email, :fullname, :avatar_image

    def self.model_name
      ActiveModel::Name.new(self, nil, 'User')
    end

    def submit(user_id)
      ProfileContext::UpdateFieldsOperation.call(user_id, instance_values) do |result|
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
