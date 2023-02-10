# frozen_string_literal: true

require 'rails_helper'

describe 'Show user info', type: :feature do
  let(:admin) { create(:user, :admin) }

  before do
    login_as(admin)
    visit admin_user_path(admin.id)
  end

  describe 'When the user can see user' do
    it 'expect see user info' do
      expect(page).to have_content(admin.fullname)
      expect(page).to have_content(admin.email)
    end
  end
end
