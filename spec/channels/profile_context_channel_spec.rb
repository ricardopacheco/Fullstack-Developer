# frozen_string_literal: true

require 'rails_helper'

describe ProfileContextChannel do
  let(:user) { create(:user) }

  describe 'when user is not profile' do
    let(:admin) { create(:user, :admin) }

    before do
      stub_connection(current_user: admin)
      subscribe
    end

    it 'rejects subscription' do
      expect(subscription).to be_rejected
    end
  end

  describe 'when user is a profile' do
    before do
      stub_connection(current_user: user)
      subscribe
    end

    it 'successfully subscribes in ProfileContextChannel' do
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("ProfileContextChannel-#{user.id}")
    end
  end
end
