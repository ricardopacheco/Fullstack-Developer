# frozen_string_literal: true

RSpec.describe ApplicationCable::Connection do
  context 'when user is not authenticated' do
    it 'rejects connection' do
      expect { connect '/cable' }.to have_rejected_connection
    end
  end

  context 'when user is authenticated' do
    let(:user) { create(:user) }

    before do
      login_as(user)
      cookies.signed[:user_id] = user.id

      connect '/cable'
    end

    it 'successfully connects' do
      expect(connection.current_user).to eq(user)
    end
  end
end
