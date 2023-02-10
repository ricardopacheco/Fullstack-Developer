# frozen_string_literal: true

require 'rails_helper'

describe 'Login', type: :feature do
  before { visit root_path }

  describe 'when credentials are invalid' do
    let(:user) { create(:user) }

    it 'expect see validation error messages' do
      within('#new-login') do
        fill_in('user_email', with: user.email)
        fill_in('user_password', with: 'invalid_password')
      end

      click_on I18n.t('login', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'email'))
    end
  end

  describe 'when credentials are valid' do
    let(:user) { create(:user) }

    it 'expect see success flash message' do
      within('#new-login') do
        fill_in('user_email', with: user.email)
        fill_in('user_password', with: user.password)
      end

      click_on I18n.t('login', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('sessions.create.success'))
    end
  end
end
