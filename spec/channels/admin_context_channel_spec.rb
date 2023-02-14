# frozen_string_literal: true

require 'rails_helper'

describe AdminContextChannel do
  let(:admin) { create(:user, :admin) }

  describe 'when user is not admin' do
    let(:user) { create(:user) }

    before do
      stub_connection(current_user: user)
      subscribe
    end

    it 'rejects subscription' do
      expect(subscription).to be_rejected
    end
  end

  describe 'when user is a admin' do
    before do
      stub_connection(current_user: admin)
      subscribe
    end

    it 'successfully subscribes in AdminContextChannel' do
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from('AdminContextChannel')
    end
  end
end
