# frozen_string_literal: true

module AdminContext
  # This class provides a layer of data validation for creating users of admin context.
  class CreateUserContract < ApplicationContract
    # :reek:DuplicateCode
    option :admin_repo, default: proc { ::User }

    params do
      required(:fullname)
      required(:email)
      optional(:avatar_image)

      before(:value_coercer) do |result|
        result.to_h.compact_blank!.merge!(role: :admin)
      end
    end

    rule(:email).validate(:email_format)
    rule(:fullname).validate(:fullname_format)

    rule(:email) do |context:|
      if key?
        context[:admin] ||= admin_repo.find_by(email: value)
        next if context[:admin].blank?

        key.failure(I18n.t('errors.messages.taken'))
      end
    end
  end
end
