# frozen_string_literal: true

module ProfileContext
  # This operation class provides provides a base operation to update current_user password.
  class UpdatePasswordOperation < OperationBase
    def self.call(user_id, attributes, &block)
      service = new.call(user_id, attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(user_id, attributes)
      user = yield find_and_validate_user_profile(user_id)
      validated_attributes = yield validate_update_password_contract(user, attributes)
      user = yield update_user_password(user, validated_attributes[:password])

      Success(user)
    end

    def validate_update_password_contract(user, attributes)
      contract = ProfileContext::UpdatePasswordContract.new.call(attributes, user: user)

      return Success(contract.to_h) if contract.success?

      Failure(contract.errors)
    end
  end
end
