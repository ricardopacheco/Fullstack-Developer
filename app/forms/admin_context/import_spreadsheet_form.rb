# frozen_string_literal: true

module AdminContext
  # Form class to allow admin create users by upload xls file. Receive data via
  # html form and call operation.
  class ImportSpreadsheetForm < ApplicationForm
    attr_reader :counter
    attr_accessor :file

    def self.model_name
      ActiveModel::Name.new(self, nil, 'Import')
    end

    def submit(admin_id)
      AdminContext::ImportSpreadsheetOperation.call(admin_id, file) do |result|
        result.success do |count|
          @counter = count
        end
        result.failure do |failure|
          copy_error_messages(failure.to_h)

          false
        end
      end
    end
  end
end
