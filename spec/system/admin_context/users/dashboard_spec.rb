# frozen_string_literal: true

require 'rails_helper'

describe 'Dashboard', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
    visit admin_root_path
  end

  describe 'After admin logged in' do
    it 'expect see some stats' do
      expect(page).to have_content(I18n.t('views.admin.dashboard.total_users'))
      expect(page).to have_content(I18n.t('views.admin.dashboard.total_grouped'))
    end
  end
end
