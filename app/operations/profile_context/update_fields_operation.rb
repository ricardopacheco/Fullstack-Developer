# frozen_string_literal: true

module ProfileContext
  # This operation class provides provides a base operation to update a profile
  # attributes in database.
  class UpdateFieldsOperation < OperationBase
    def self.call(user_id, attributes, &block)
      service = new.call(user_id, attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(user_id, attributes)
      user = yield find_and_validate_user_profile(user_id)
      validated_attributes = yield validate_contract(ProfileContext::UpdateFieldsContract, attributes)
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
