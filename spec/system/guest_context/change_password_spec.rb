# frozen_string_literal: true

require 'rails_helper'

describe 'Create a new password', type: :feature do
  let(:user) { create(:user, :with_token) }

  before { visit guest_create_password_path(user.token) }

  describe 'when attributes are invalid' do
    it 'expect see error messages' do
      within('#registration-create-new-password') do
        fill_in('user_password', with: '')
        fill_in('user_password_confirmation', with: '')
      end

      click_on I18n.t('create_password', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('contracts.errors.key?'))
    end
  end

  describe 'when attributes are valid' do
    it 'expect see create password success message' do
      within('#registration-create-new-password') do
        find_field(id: 'user_token', type: :hidden).set(user.token)
        fill_in('user_password', with: user.password)
        fill_in('user_password_confirmation', with: user.password)
      end

      click_on I18n.t('create_password', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('registrations.update_password.success'))
    end
  end
end
