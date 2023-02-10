# frozen_string_literal: true

module I18n
  # Makes translation missing errors be raised as an exception during
  # test suite execution. It helps locate missing translations.
  class RaiseMissingTranslationHandler < ExceptionHandler
    # :reek:LongParameterList
    def call(exception, locale, key, options)
      if exception.is_a?(MissingTranslation)
        raise exception.to_exception
      else
        super
      end
    end
  end
end
