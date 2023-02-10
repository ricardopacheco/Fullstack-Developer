# frozen_string_literal: true

# This class is a Ruby class that inherits from the Dry::Validation::Contract class.
# It provides an input validation mechanism for applications. The class contains
# validation methods that can be used to ensure that the input data is valid and
# in the correct format before it is processed.
class ApplicationContract < Dry::Validation::Contract
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  MIN_FULLNAME_LENGTH = 3
  MAX_FULLNAME_LENGTH = 255
  MIN_PASSWORD_LENGTH = Rails.configuration.x.min_password_length
  MAX_PASSWORD_LENGTH = Rails.configuration.x.max_password_length

  config.messages.backend = :i18n
  config.messages.default_locale = I18n.default_locale
  config.messages.top_namespace = 'contracts'

  register_macro(:email_format) do
    key.failure(I18n.t('contracts.errors.custom.macro.email_format')) unless EMAIL_REGEX.match?(value)
  end

  register_macro(:fullname_format) do
    if key? && !value.length.between?(MIN_FULLNAME_LENGTH, MAX_FULLNAME_LENGTH)
      key.failure(
        I18n.t(
          'contracts.errors.custom.macro.fullname_format',
          min: MIN_FULLNAME_LENGTH, max: MAX_FULLNAME_LENGTH
        )
      )
    end
  end

  register_macro(:password_format) do
    unless value.length.between?(MIN_PASSWORD_LENGTH, MAX_PASSWORD_LENGTH)
      key.failure(
        I18n.t(
          'contracts.errors.custom.macro.password_format',
          min: MIN_PASSWORD_LENGTH,
          max: MAX_PASSWORD_LENGTH
        )
      )
    end
  end
end
