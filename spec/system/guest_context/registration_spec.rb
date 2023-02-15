# frozen_string_literal: true

require 'rails_helper'

describe 'Registration', type: :feature do
  before { visit register_path }

  describe 'when profile data are invalid' do
    let(:user) { create(:user) }

    it 'expect see error messages' do
      within('#new-registration') do
        fill_in('user_email', with: '')
        fill_in('user_fullname', with: '')
        fill_in('user_password', with: '')
        fill_in('user_password_confirmation', with: '')
      end

      click_on I18n.t('register', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('contracts.errors.key?'))
    end
  end

  describe 'when profile data are valid' do
    let(:user) { attributes_for(:user) }

    it 'expect see welcome message' do
      within('#new-registration') do
        fill_in('user_email', with: user[:email])
        fill_in('user_fullname', with: user[:fullname])
        fill_in('user_password', with: user[:password])
        fill_in('user_password_confirmation', with: user[:password_confirmation])
      end

      click_on I18n.t('register', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('registrations.create.success'))
    end
  end
end
