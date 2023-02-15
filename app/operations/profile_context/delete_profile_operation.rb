# frozen_string_literal: true

module ProfileContext
  # This operation class provides provides a base operation to delete a
  # current_user profile user on database.
  class DeleteProfileOperation < OperationBase
    def self.call(attributes, &block)
      service = new.call(attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(user_id)
      ActiveRecord::Base.transaction do
        yield delete_user_on_database(user_id)
        yield send_admin_context_delete_user_broadcast(user_id)
      end

      Success(nil)
    end

    private

    def send_admin_context_delete_user_broadcast(user_id)
      Success(ProfileContext::DeleteUserBroadcastJob.perform_later(user_id))
    end
  end
end
