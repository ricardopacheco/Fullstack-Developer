# frozen_string_literal: true

module ProfileContext
  # This class provides a layer of data validation for creating users of profile kind.
  class CreateProfileUserContract < ApplicationContract
    # :reek:DuplicateCode
    option :user_repo, default: proc { ::User }

    params do
      required(:fullname)
      required(:email)
      required(:password)
      required(:password_confirmation)
      optional(:avatar_image)

      before(:value_coercer) do |result|
        result.to_h.compact_blank!.merge!(role: :profile)
      end
    end

    rule(:email).validate(:email_format)
    rule(:fullname).validate(:fullname_format)
    rule(:password).validate(:password_format)
    rule(:password_confirmation).validate(:password_format)

    rule(:email) do |context:|
      if key?
        context[:user] ||= user_repo.find_by(email: value)
        next if context[:user].blank?

        key.failure(I18n.t('errors.messages.taken'))
      end
    end

    rule(:password, :password_confirmation) do
      if !rule_error?(:password) && values[:password] != values[:password_confirmation]
        key(:password_confirmation).failure(I18n.t('errors.messages.confirmation'))
      end
    end
  end
end
