# frozen_string_literal: true

require 'rails_helper'

describe 'Delete Own Profile', type: :feature do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit profile_root_path
  end

  describe 'When the user can delete own profile' do
    it 'expect delete and redirect' do
      click_on(id: 'navbar-profile-btn-delete')

      expect(page).to have_content(I18n.t('profiles.destroy.success'))
      expect(page).to have_current_path(root_path)
    end
  end

  describe 'When the user cannot delete own profile' do
    before do
      allow(User).to receive(:find_by).and_return(user)
      allow(user).to receive(:destroy).and_return(false)
    end

    it 'expect see error message' do
      click_on(id: 'navbar-profile-btn-delete')

      expect(page).to have_content(I18n.t('profiles.destroy.error'))
    end
  end
end
