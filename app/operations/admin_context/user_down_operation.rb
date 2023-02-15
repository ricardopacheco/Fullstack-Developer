# frozen_string_literal: true

module AdminContext
  # This operation class provides a base operation to convert a admin user in a
  # profile user. The operation is only accessible by admin users.
  class UserDownOperation < OperationBase
    def self.call(admin_id, user_id, &block)
      service = new.call(admin_id, user_id)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(admin_id, admin_user_id)
      yield myself?(admin_id, admin_user_id)
      yield find_and_validate_user_admin(admin_id)
      user = yield find_user(admin_user_id)

      return Success(user) unless user.admin?

      ActiveRecord::Base.transaction do
        user = yield convert_admin_to_user(user)
      end

      Success(user)
    end

    private

    def convert_admin_to_user(user)
      return Success(user) if user.profile!

      Failure(base: I18n.t('operations.admin_context.user_down_operation.error'))
    end
  end
end
