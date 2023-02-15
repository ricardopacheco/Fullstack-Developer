# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::DeleteUserBroadcastJob do
  describe '#perform' do
    let(:fake_user_id) { rand(1..10) }

    context 'when user is deleted from database' do
      it 'broadcasts with old user id' do
        allow(ActionCable.server).to receive(:broadcast).and_return(true)

        described_class.perform_now(fake_user_id)

        expect(ActionCable.server).to have_received(:broadcast).twice
      end
    end
  end
end
