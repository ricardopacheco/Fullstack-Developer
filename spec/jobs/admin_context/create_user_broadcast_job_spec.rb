# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::CreateUserBroadcastJob do
  describe '#perform' do
    context 'when user is founded on database' do
      let(:user) { create(:user) }

      it 'broadcasts user data' do
        allow(ActionCable.server)
          .to receive(:broadcast)
          .with(
            'AdminContextChannel', {
              type: 'CRATE_USER',
              payload: user.slice(:id, :email, :fullname, :role)
            }
          )
          .and_return(true)

        described_class.perform_now(user.id)

        expect(ActionCable.server)
          .to have_received(:broadcast)
          .with(
            'AdminContextChannel', {
              type: 'CRATE_USER',
              payload: user.slice(:id, :email, :fullname, :role)
            }
          ).once
      end
    end

    context 'when user is not founded on database' do
      let(:not_found_user_id) { SecureRandom.hex(10) }

      it 'raises error' do
        expect { described_class.perform_now(not_found_user_id) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
