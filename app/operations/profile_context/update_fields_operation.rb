# frozen_string_literal: true

module ProfileContext
  # This operation class provides a base operation to allow current profile update
  # some attributes from your profile in database. The operation is only accessible
  # by current profile
  class UpdateFieldsOperation < OperationBase
    def self.call(user_id, attributes, &block)
      service = new.call(user_id, attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(user_id, attributes)
      user = yield find_and_validate_user_profile(user_id)
      validated_attributes = yield validate_contract(ProfileContext::UpdateFieldsContract, attributes)

      ActiveRecord::Base.transaction do
        user = yield update_user_attributes(user, validated_attributes)
        yield send_admin_context_update_user_broadcast(user.id)

        Success(user)
      end
    end

    private

    def update_user_attributes(user, attributes)
      return Success(user) if user.update(attributes)

      Failure(user.errors.to_hash)
    end

    def send_admin_context_update_user_broadcast(user_id)
      Success(ProfileContext::UpdateUserBroadcastJob.perform_later(user_id))
    end
  end
end
