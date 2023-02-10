# frozen_string_literal: true

# This class is an abstraction for an intermediate layer between the business
# operation and rails views.
class ApplicationForm
  include ActiveModel::API

  def persisted?
    false
  end

  def copy_error_messages(hash)
    hash.each { |key, value| errors.add(key, value.join(', ')) }
  end
end
