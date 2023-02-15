# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection do
  let(:env) { instance_double('env') }
  let(:warden) { instance_double('warden', user: user) }

  before do
    allow_any_instance_of(ActionCable::Connection::TestRequest).to receive(:env).and_return(env)
    allow(env).to receive(:[]).with('warden').and_return(warden)
  end

  describe 'when user is not authenticated' do
    let(:user) { instance_double(User, id: nil) }

    it 'rejects connection' do
      expect { connect '/cable' }.to have_rejected_connection
    end
  end

  describe 'when user is authenticated' do
    let(:user) { create(:user) }

    before { connect '/cable' }

    it 'successfully connects' do
      expect(connection.current_user).to eq(user)
    end
  end
end
