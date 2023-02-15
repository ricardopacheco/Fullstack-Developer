# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::ImportSpreadsheetBroadcastJob do
  describe '#perform' do
    context 'when users is founded on database' do
      let(:user_ids) { create_list(:user, 2).map(&:id) }

      it 'broadcasts user data' do
        allow(ActionCable.server).to receive(:broadcast).and_return(true)

        described_class.perform_now(user_ids)

        expect(ActionCable.server).to have_received(:broadcast).once
      end
    end

    context 'when users is not founded on database' do
      let(:user_ids) { [] }

      it 'expect not call broadcast data' do
        allow(ActionCable.server).to receive(:broadcast).and_return(true)

        described_class.perform_now(user_ids)

        expect(ActionCable.server).not_to have_received(:broadcast)
      end
    end
  end
end
