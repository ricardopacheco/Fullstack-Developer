# frozen_string_literal: true

module AdminContext
  # Form class to allow admin update a user data. Receive data via html form and
  # call operation.
  class EditUserForm < ApplicationForm
    attr_accessor :user, :email, :fullname, :avatar_image, :cached_avatar_image_data

    def initialize(attributes = {})
      super(attributes)
      @user = attributes[:user]
      @email = @user.try(:email) || attributes[:email]
      @fullname = @user.try(:fullname) || attributes[:fullname]
      @avatar_image = @user.try(:avatar_image) || attributes[:avatar_image]
      @cached_avatar_image_data = @user.try(:cached_avatar_image_data) || attributes[:cached_avatar_image_data]
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, 'User')
    end

    def submit(admin_id, user_id)
      AdminContext::UpdateUserOperation.call(admin_id, user_id, instance_values) do |result|
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
