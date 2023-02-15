# frozen_string_literal: true

module AdminContext
  # This operation class provides a base operation when a admin updates a user
  # in database. The operation is only accessible by admin users.
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

      ActiveRecord::Base.transaction do
        user = yield update_user_attributes(user, validated_attributes)
        yield send_admin_context_update_user_broadcast(user.id)
      end

      Success(user)
    end

    private

    def update_user_attributes(user, attributes)
      return Success(user) if user.update(attributes)

      Failure(user.errors.to_hash)
    end

    def send_admin_context_update_user_broadcast(user_id)
      Success(AdminContext::UpdateUserBroadcastJob.perform_later(user_id))
    end
  end
end
