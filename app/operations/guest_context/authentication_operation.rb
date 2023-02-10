# frozen_string_literal: true

module GuestContext
  # This operation class provides provides a base operation to authenticate users.
  class AuthenticationOperation < OperationBase
    def self.call(attributes, &block)
      service = new.call(attributes)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(attributes)
      user = yield validate_authentication_contract(attributes)

      Success(user)
    end

    private

    # Override method.
    def validate_authentication_contract(attributes)
      contract = GuestContext::AuthenticationContract.new.call(attributes)

      return Success(contract.context[:user]) if contract.success?

      Failure(contract.errors)
    end
  end
end
