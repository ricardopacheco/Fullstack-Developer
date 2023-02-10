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
      completed_attributes = yield add_random_password_to_attributes(validated_attributes)

      ActiveRecord::Base.transaction do
        @user = yield create_user_on_database(completed_attributes)
        yield send_welcome_email_to_user(@user)
      end

      Success(@user)
    end
  end
end
