# frozen_string_literal: true

module GuestContext
  # This operation class provides provides a base operation to authenticate users.
  class CreatePasswordOperation < OperationBase
    def self.call(attributes, &block)
      service = new.call(attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(attributes)
      user, validated_attributes = yield validate_create_password_contract(attributes)

      ActiveRecord::Base.transaction do
        user = yield update_user_password(user, validated_attributes[:password])
        user = yield clean_user_token(user)

        Success(user)
      end
    end

    private

    def validate_create_password_contract(attributes)
      contract = GuestContext::CreatePasswordContract.new.call(attributes)

      return Success([contract.context[:user], contract.to_h]) if contract.success?

      Failure(contract.errors)
    end

    def clean_user_token(user)
      return Success(user) if user.update(token: nil)

      Failure(user.errors.to_hash)
    end
  end
end
