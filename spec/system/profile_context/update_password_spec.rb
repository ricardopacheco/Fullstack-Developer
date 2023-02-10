# frozen_string_literal: true

require 'rails_helper'

describe 'Update Password', type: :feature do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit change_password_profile_path
  end

  describe 'When the user edits data incorrectly' do
    it 'expect see validation error messages' do
      within('#profile-update-password-form') do
        fill_in('user_current_password', with: '')
        fill_in('user_password', with: '')
        fill_in('user_password_confirmation', with: '')
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('contracts.errors.key?'))
    end
  end

  describe 'When the user edits the data correctly' do
    it 'expect redirect user and update password' do
      within('#profile-update-password-form') do
        fill_in('user_current_password', with: 'password')
        fill_in('user_password', with: 'new_password')
        fill_in('user_password_confirmation', with: 'new_password')
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('profiles.update_password.success'))
    end
  end
end
