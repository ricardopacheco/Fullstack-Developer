# frozen_string_literal: true

module ProfileContext
  # This class provides a layer of data validation for creating users of profile kind.
  class UpdatePasswordContract < ApplicationContract
    # :reek:DuplicateCode
    option :user_repo, default: proc { ::User }

    params do
      required(:password)
      required(:password_confirmation)
      required(:current_password)

      before(:value_coercer) do |result|
        result.to_h.compact_blank!
      end
    end

    rule(:password).validate(:password_format)
    rule(:password_confirmation).validate(:password_format)
    rule(:password_confirmation).validate(:password_format)

    rule(:password, :password_confirmation) do
      if !rule_error?(:password) && values[:password] != values[:password_confirmation]
        key(:password_confirmation).failure(
          I18n.t('errors.messages.confirmation', attribute: 'password')
        )
      end
    end

    rule(:current_password) do |context:|
      user = context[:user]

      next if !rule_error?(:password) && user.present? && user.valid_password?(values[:current_password])

      key(:current_password).failure(I18n.t('errors.messages.invalid'))
    end
  end
end
