# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminContext::DashboardDecorator do
  subject { described_class.new(current_user) }

  let(:current_user) { instance_double(User) }

  describe '#total_users' do
    before { allow(User).to receive(:count).and_return(100) }

    it 'expects render the total' do
      expect(subject.total_users).to eq(100)
    end
  end

  describe '#render_grouped_users_by_role' do
    context 'when the user has a role' do
      before { allow(User).to receive(:group).and_return({ 'role' => 1 }) }

      it 'groups users by role' do
        expect(subject.render_grouped_users_by_role).to eq(1)
      end
    end

    context 'when the user has no role' do
      it 'returns an empty group' do
        expect(subject.render_grouped_users_by_role).to eq({})
      end
    end
  end
end
