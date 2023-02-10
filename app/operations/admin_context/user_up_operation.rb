# frozen_string_literal: true

module AdminContext
  # This operation class provides provides a base operation to convert a profile
  # user in a admin user. The operation is only accessible by admin users.
  class UserUpOperation < OperationBase
    def self.call(admin_id, user_id, &block)
      service = new.call(admin_id, user_id)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(admin_id, user_id)
      yield myself?(admin_id, user_id)
      yield find_and_validate_user_admin(admin_id)
      user = yield find_and_validate_user_profile(user_id)

      ActiveRecord::Base.transaction do
        user = yield convert_user_on_admin(user)
      end

      Success(user)
    end

    private

    def convert_user_on_admin(user)
      return Success(user) if user.admin!

      Failure(base: I18n.t('operations.admin_context.user_up_operation.error'))
    end
  end
end
