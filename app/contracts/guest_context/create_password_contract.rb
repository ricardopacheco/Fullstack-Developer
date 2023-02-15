# frozen_string_literal: true

module GuestContext
  # This class provides a layer of data validation for create new password for users.
  class CreatePasswordContract < ApplicationContract
    option :user_repo, default: proc { ::User }

    params do
      required(:token)
      required(:password)
      required(:password_confirmation)

      before(:value_coercer) do |result|
        result.to_h.compact_blank!
      end
    end

    rule(:password).validate(:password_format)
    rule(:password_confirmation).validate(:password_format)

    rule do |context:|
      if key?(:token)
        context[:user] ||= user_repo.find_by(token: values[:token])
        next if context[:user].present?

        key(:base).failure(I18n.t('errors.messages.token_not_found'))
      end
    end
  end
end
