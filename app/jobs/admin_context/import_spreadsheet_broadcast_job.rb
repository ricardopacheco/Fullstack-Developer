# frozen_string_literal: true

module AdminContext
  # This job is used to broadcast messages to all admins when a admin imports a
  # spreadsheet.
  class ImportSpreadsheetBroadcastJob < ApplicationJob
    queue_as :broadcast

    def perform(user_ids)
      users = User.where(id: user_ids)

      return if users.blank?

      ActionCable.server.broadcast(
        'AdminContextChannel',
        build_import_data('ADMIN_IMPORT_SPREADSHEET', users)
      )
    end
  end
end
