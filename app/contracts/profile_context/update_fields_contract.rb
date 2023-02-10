# frozen_string_literal: true

module ProfileContext
  # This class provides a layer of data validation for update profile attributes.
  class UpdateFieldsContract < ApplicationContract
    # :reek:DuplicateCode
    option :user_repo, default: proc { ::User }

    params do
      optional(:fullname)
      optional(:email)
      optional(:avatar_image)

      before(:value_coercer) do |result|
        result.to_h.compact_blank!
      end
    end

    rule(:email).validate(:email_format)
    rule(:fullname).validate(:fullname_format)
  end
end
