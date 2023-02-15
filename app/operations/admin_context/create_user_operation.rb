# frozen_string_literal: true

module AdminContext
  # This operation class provides provides a base operation to create a new
  # admin user on database. The operation is only accessible by admin users.
  class CreateUserOperation < OperationBase
    def self.call(admin_id, attributes, &block)
      service = new.call(admin_id, attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(admin_id, attributes)
      yield find_and_validate_user_admin(admin_id)
      validated_attributes = yield validate_contract(AdminContext::CreateUserContract, attributes)
      attributes_with_random_pass = yield add_random_password_to_attributes(validated_attributes)
      completed_attributes = yield add_token_to_attributes(attributes_with_random_pass)

      ActiveRecord::Base.transaction do
        @user = yield create_user_on_database(completed_attributes)
        yield send_welcome_email_to_user(@user)
        yield send_admin_context_create_user_broadcast(@user.id)
      end

      Success(@user)
    end

    private

    def add_token_to_attributes(attributes)
      Success(attributes.merge!(token: generate_user_token))
    end

    def send_admin_context_create_user_broadcast(user_id)
      Success(AdminContext::CreateUserBroadcastJob.perform_later(user_id))
    end

    def generate_user_token
      SecureRandom.hex(10)
    end
  end
end
