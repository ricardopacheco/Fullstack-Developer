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
      yield delete_user_on_database(user_id)

      Success(nil)
    end
  end
end
