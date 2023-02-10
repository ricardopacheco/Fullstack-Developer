# frozen_string_literal: true

require 'rails_helper'

describe 'List all users', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
    visit admin_users_path
  end

  describe 'When the user can list all users' do
    it 'expect see all users' do
      expect(page).to have_content(admin.fullname)
      expect(page).to have_content(admin.email)
    end
  end
end
