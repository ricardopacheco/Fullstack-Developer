# frozen_string_literal: true

require 'rails_helper'

describe 'Update Profile Data', type: :feature do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit edit_profile_path
  end

  describe 'When the user edits data incorrectly' do
    it 'expect see validation error messages' do
      within('#profile-update-form') do
        fill_in('user_fullname', with: '')
        fill_in('user_email', with: '')
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('contracts.errors.custom.macro.email_format'))
    end
  end

  describe 'When the user edits the data correctly' do
    let(:new_fullname) { 'New Fullname' }
    let(:new_email) { 'email@changed.com' }

    it 'expect redirect user and update profile data' do
      within('#profile-update-form') do
        fill_in('user_fullname', with: new_fullname)
        fill_in('user_email', with: new_email)
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('profiles.update.success'))
    end
  end
end
