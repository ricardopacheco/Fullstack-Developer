# frozen_string_literal: true

module GuestContext
  # This class provides a layer of data validation for authenticate users.
  class AuthenticationContract < ApplicationContract
    option :user_repo, default: proc { ::User }

    params do
      required(:email)
      required(:password)

      before(:value_coercer) do |result|
        result.to_h.compact_blank!
      end
    end

    rule(:email).validate(:email_format)
    rule(:password).validate(:password_format)

    rule do |context:|
      if key?(:email) && key?(:password)
        context[:user] ||= user_repo.find_by(email: values[:email])
        next if context[:user].present? && context[:user].valid_password?(values[:password])

        key(:base).failure(I18n.t('devise.failure.invalid', authentication_keys: 'email'))
      end
    end
  end
end
