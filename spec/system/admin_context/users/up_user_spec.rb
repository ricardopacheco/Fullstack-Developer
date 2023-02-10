# frozen_string_literal: true

require 'rails_helper'

describe 'Convert user admin in a user profile', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  before do
    login_as(admin)
    visit admin_user_path(user.id)
  end

  describe "When admin can't convert user to admin for some reason" do
    before do
      allow(User).to receive(:find_by).with(id: admin.id).and_return(user)
      allow(User).to receive(:find_by).with(id: user.id).and_return(user)
      allow(user).to receive(:admin!).and_return(false)
    end

    it 'expect not change user role and show error message' do
      click_on 'Convert to admin'

      expect(page).to have_current_path(edit_admin_user_path(user.id))
      expect(page).to have_content(I18n.t('admin.users.up.error', fullname: user.fullname))
    end
  end

  describe 'When admin can convert user' do
    it 'expect change user role from profile to admin' do
      click_on 'Convert to admin'

      expect(page).to have_current_path(admin_user_path(user.id))
      expect(page).to have_content(I18n.t('admin.users.up.success', fullname: user.fullname))
    end
  end
end
