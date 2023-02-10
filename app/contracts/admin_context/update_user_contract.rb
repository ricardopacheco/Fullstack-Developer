# frozen_string_literal: true

module AdminContext
  # This class provides a layer of data validation for update users in admin context.
  class UpdateUserContract < ApplicationContract
    # :reek:DuplicateCode
    option :admin_repo, default: proc { ::User }

    params do
      optional(:fullname)
      optional(:email)
      optional(:avatar_image)

      before(:value_coercer) do |result|
        result.to_h.compact_blank!.merge!(role: :admin)
      end
    end

    rule(:email).validate(:email_format)
    rule(:fullname).validate(:fullname_format)
  end
end
