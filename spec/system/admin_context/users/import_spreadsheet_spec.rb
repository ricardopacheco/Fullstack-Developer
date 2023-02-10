# frozen_string_literal: true

require 'rails_helper'

describe 'Import spreadsheet', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
    visit upload_admin_users_path
  end

  describe "When admin can't import a spreadsheet" do
    it 'expect not create users and see main error message' do
      within('#admin-users-import-form') do
        attach_file('import[file]', Rails.root.join('spec/fixtures/profile_photo.png'))
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(
        I18n.t('operations.admin_context.import_spreadsheet_operation.invalid')
      )
    end
  end

  describe 'When admin can import a spreadsheet successfully' do
    it 'expect create users and see their info in list users' do
      within('#admin-users-import-form') do
        attach_file('import[file]', Rails.root.join('spec/fixtures/import/example.xlsx'))
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_current_path(admin_users_path)
      expect(page).to have_content('Import User 1')
      expect(page).to have_content('Import User 2')
    end
  end
end
