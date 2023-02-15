# frozen_string_literal: true

module AdminContext
  # This operation class provides provides a base operation to delete a user
  # on database. The operation is only accessible by admin users.
  class DeleteUserOperation < OperationBase
    def self.call(admin_id, attributes, &block)
      service = new.call(admin_id, attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(admin_id, deleted_user_id)
      yield find_and_validate_user_admin(admin_id)
      user = yield find_and_validate_user_profile(deleted_user_id)

      ActiveRecord::Base.transaction do
        yield delete_user_on_database(user)
        yield send_delete_email_to_user(user.email)
        yield send_admin_context_delete_user_broadcast(user.id)
      end

      Success(nil)
    end

    private

    def send_delete_email_to_user(email)
      Success(AdminContext::UserMailer.delete(email).deliver_later)
    end

    def send_admin_context_delete_user_broadcast(user_id)
      Success(AdminContext::DeleteUserBroadcastJob.perform_later(user_id))
    end
  end
end
