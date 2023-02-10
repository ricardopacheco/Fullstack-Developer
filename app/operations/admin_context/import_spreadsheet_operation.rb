# frozen_string_literal: true

module AdminContext
  # This operation class provides provides a base operation to import users from
  # a spreadsheet calling create user operation. The operation is only accessible
  # by admin users.
  class ImportSpreadsheetOperation < OperationBase
    I18N_SCOPE = 'operations.admin_context.import_spreadsheet_operation'

    def self.call(admin_id, xlsx_file, &block)
      service = new.call(admin_id, xlsx_file)

      return service unless block

      Dry::Matcher::ResultMatcher.call(service, &block)
    end

    def call(admin_id, xlsx_file)
      yield find_and_validate_user_admin(admin_id)
      yield validate_xlsx_file(xlsx_file)
      users = yield import_users_from_spreadsheet(xlsx_file)

      ActiveRecord::Base.transaction do
        users.each { |user_attributes| yield create_user_operation(admin_id, user_attributes) }
      end

      Success(users.size)
    end

    private

    def import_users_from_spreadsheet(xlsx_file, users = [])
      spreadsheet = Roo::Spreadsheet.open(xlsx_file)
      header = spreadsheet.row(1).map(&:downcase)

      (2..spreadsheet.last_row).each do |i|
        attributes = [header, spreadsheet.row(i)].transpose.to_h
        completed_attributes = yield add_random_password_to_attributes(attributes)

        users << completed_attributes
      end

      Success(users)
    end

    def create_user_operation(admin_id, user_attributes)
      AdminContext::CreateUserOperation.call(admin_id, user_attributes) do |result|
        result.success do |user|
          Success(user)
        end

        result.failure do |errors|
          Failure(errors)
        end
      end
    end

    def validate_xlsx_file(xlsx_file)
      return Failure(base: [I18n.t(:required, scope: I18N_SCOPE)]) if xlsx_file.blank?
      return Failure(base: [I18n.t(:invalid, scope: I18N_SCOPE)]) unless valid_file(xlsx_file)

      Success(xlsx_file)
    end

    def valid_file(xlsx_file)
      return true if MiniMime.lookup_by_filename(xlsx_file).extension == 'xlsx'

      false
    end
  end
end
