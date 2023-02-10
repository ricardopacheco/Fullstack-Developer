# frozen_string_literal: true

require 'rails_helper'

describe 'Logout', type: :feature do
  let(:user) { create(:user) }

  describe 'when user profile is logged in' do
    before do
      login_as(user)
      visit profile_root_path
    end

    it 'expect logout and redirect to guest root path' do
      click_on 'Logout'

      expect(page).to have_content(I18n.t('sessions.destroy.success'))
    end
  end
end
