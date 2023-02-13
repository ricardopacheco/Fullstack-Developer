# frozen_string_literal: true

require 'rails_helper'

describe 'Delete a user', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    login_as(admin)
    visit admin_user_path(user.id)
  end

  describe "When admin can't update a user" do
    before do
      allow(User).to receive(:find_by).with(id: admin.id).and_return(user)
      allow(User).to receive(:find_by).with(id: user.id).and_return(user)
      allow(user).to receive(:destroy).and_return(false)
    end

    it 'expect redirect to list all users without deleted user' do
      click_on(id: 'admin-btn-delete-user')

      expect(page).to have_content(I18n.t('admin.users.destroy.error'))
      expect(page).to have_current_path(edit_admin_user_path(user.id))
    end
  end

  describe 'When admin can delete a user' do
    it 'expect redirect to list all users without deleted user' do
      click_on(id: 'admin-btn-delete-user')

      expect(page).to have_content(I18n.t('admin.users.destroy.success'))
      expect(page).to have_current_path(admin_users_path)
      expect(page).not_to have_content(user.email)
    end
  end
end
