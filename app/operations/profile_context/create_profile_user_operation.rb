# frozen_string_literal: true

module ProfileContext
  # This operation class provides a base operation to register new profiles on
  # database. The operation is only accessible by admin users.
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
        yield send_admin_context_create_user_broadcast(user.id)

        Success(user)
      end
    end

    private

    def send_admin_context_create_user_broadcast(user_id)
      Success(ProfileContext::CreateUserBroadcastJob.perform_later(user_id))
    end
  end
end
