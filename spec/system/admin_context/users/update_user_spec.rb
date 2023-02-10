# frozen_string_literal: true

require 'rails_helper'

describe 'Update user', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    login_as(admin)
    visit edit_admin_user_path(user.id)
  end

  describe "When admin can't update a user" do
    it 'expect see user info' do
      within('#admin-users-edit-form') do
        fill_in('user_email', with: '')
        fill_in('user_fullname', with: '')
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('contracts.errors.custom.macro.email_format'))
      expect(page).to have_current_path(admin_user_path(user.id))
    end
  end

  describe 'When admin can update a user successfully' do
    let(:changed_user) { attributes_for(:user) }

    it 'expect see error messages' do
      within('#admin-users-edit-form') do
        fill_in('user_email', with: changed_user[:email])
        fill_in('user_fullname', with: changed_user[:fullname])
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('admin.users.update.success'))

      expect(page).to have_content(changed_user[:email])
      expect(page).to have_content(changed_user[:fullname])
      expect(page).to have_current_path(admin_user_path(user.id))
    end
  end
end
