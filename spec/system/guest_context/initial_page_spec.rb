# frozen_string_literal: true

require 'rails_helper'

describe 'Initial Page', type: :feature do
  it 'expect see welcome message' do
    visit '/'
    expect(page).to have_content(I18n.t('views.guest.sign_in'))
  end
end
