# frozen_string_literal: true

module AdminContext
  # This operation class provides provides a base operation to update user
  # attributes in database.
  class UpdateUserOperation < OperationBase
    def self.call(admin_id, user_id, attributes, &block)
      service = new.call(admin_id, user_id, attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(admin_id, user_id, attributes)
      yield find_and_validate_user_admin(admin_id)
      user = yield find_user(user_id)
      validated_attributes = yield validate_contract(AdminContext::UpdateUserContract, attributes)
      user = yield update_user_attributes(user, validated_attributes)

      Success(user)
    end

    private

    def update_user_attributes(user, attributes)
      return Success(user) if user.update(attributes)

      Failure(user.errors.to_hash)
    end
  end
end
