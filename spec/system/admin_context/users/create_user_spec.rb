# frozen_string_literal: true

require 'rails_helper'

describe 'Create user', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
    visit new_admin_user_path
  end

  describe "When admin can't create a user" do
    it 'expect see user info' do
      within('#admin-users-new-form') do
        fill_in('user_email', with: '')
        fill_in('user_fullname', with: '')
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(I18n.t('contracts.errors.key?'))
      expect(page).to have_current_path(admin_users_path)
    end
  end

  describe 'When admin can create a user successfully' do
    let(:user) { attributes_for(:user) }
    let(:last_user_created_id) { User.last.id }

    it 'expect see error messages' do
      within('#admin-users-new-form') do
        fill_in('user_email', with: user[:email])
        fill_in('user_fullname', with: user[:fullname])
      end

      click_on I18n.t('submit', scope: 'simple_form.buttons')

      expect(page).to have_content(user[:email])
      expect(page).to have_content(user[:fullname])
      expect(page).to have_current_path(admin_user_path(last_user_created_id))
    end
  end
end
