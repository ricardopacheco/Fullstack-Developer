# frozen_string_literal: true

require 'rails_helper'

describe ProfileContext::DeleteProfileOperation, type: :operation do
  let!(:user) { create(:user) }

  describe '.call(user_id, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        let(:user_id) { user.id }

        it 'expect result success matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(user_id) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure).to be_nil
        end
      end

      context 'when operation happens with failure' do
        let(:user_id) { nil }

        it 'expect result matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(user_id) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure[:base]).to eq(I18n.t('operations.base.profile_not_found'))
        end
      end
    end
  end

  describe '#call(user_id)' do
    subject(:operation) { described_class.new.call(user_id) }

    let(:user_id) { user.id }

    context 'when user_id is not found' do
      let(:user_id) { nil }

      it 'expect return failure with error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.profile_not_found'))
      end
    end

    context 'when model invalidates record removal' do
      let(:user_model_class) { User }

      before do
        allow(user_model_class).to receive(:find_by).with(id: user.id).and_return(user)
        allow(user).to receive(:destroy).and_return(false)
        allow(user)
          .to receive(:errors)
          .and_return(
            ActiveModel::Errors.new(user_model_class.new).tap do |e|
              e.add(:email, I18n.t('errors.messages.taken'))
            end
          )
      end

      it 'expect return failure and return model error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:email]).to include(I18n.t('errors.messages.taken'))
      end
    end

    context 'when user_id exists and are valid' do
      it 'expect operation return success' do
        expect(operation).to be_success
      end

      it 'expect delete a profile from database' do
        expect { operation }.to change(User.profile, :count).from(1).to(0)
      end

      it 'expect send broadcast event' do
        expect do
          operation
        end.to(
          have_enqueued_job(ProfileContext::DeleteUserBroadcastJob).on_queue('broadcast')
        )
      end
    end
  end
end
