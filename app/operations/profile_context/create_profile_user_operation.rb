# frozen_string_literal: true

module ProfileContext
  # This operation class provides provides a base operation to create a new
  # profile user on database. The operation is only accessible by admin users.
  class CreateProfileUserOperation < OperationBase
    def self.call(attributes, &block)
      service = new.call(attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(attributes)
      validated_attributes = yield validate_contract(ProfileContext::CreateProfileUserContract, attributes)

      ActiveRecord::Base.transaction do
        user = yield create_user_on_database(validated_attributes)
        Success(user)
      end
    end
  end
end
