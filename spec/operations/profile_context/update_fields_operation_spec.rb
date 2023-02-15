# frozen_string_literal: true

require 'rails_helper'

describe ProfileContext::UpdateFieldsOperation, type: :operation do
  let(:user) { create(:user) }

  describe '.call(user_id, attributes, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        let(:attributes) do
          {
            fullname: 'New Fullname',
            email: 'umenailhas@lkjsao.com'
          }
        end

        it 'expect result success matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(user.id, attributes) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_a(User)
          expect(matched_failure).to be_nil
        end
      end

      context 'when operation happens with failure' do
        let(:attributes) { {} }

        it 'expect result matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(nil, attributes) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure[:base]).to eq(I18n.t('operations.base.profile_not_found'))
        end
      end
    end
  end

  describe '#call(user_id, attributes)' do
    subject(:operation) { described_class.new.call(user_id, attributes) }

    let(:user_id) { user.id }
    let(:attributes) do
      {
        fullname: 'New Fullname',
        email: 'umenailhas@lkjsao.com'
      }
    end

    context 'when contract is invalid' do
      let(:attributes) { { email: 'invalid' } }

      it 'expect return failure with error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:email]).to include(
          I18n.t('contracts.errors.custom.macro.email_format')
        )
      end
    end

    context 'when model invalidate any attribute' do
      let(:user_model_class) { User }

      before do
        allow(user_model_class).to receive(:find_by).and_return(user)
        allow(user).to receive(:update).and_return(false)
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

    context 'when attributes are valid' do
      it 'expect operation return success and update fields' do
        expect(operation).to be_success
      end

      it 'expect update a fullname field' do
        expect { operation }
          .to change { user.reload.fullname }
          .from(user.fullname)
          .to(attributes[:fullname])
      end

      it 'expect update a email field' do
        expect { operation }
          .to change { user.reload.email }
          .from(user.email)
          .to(attributes[:email])
      end

      it 'expect send broadcast event' do
        expect do
          operation
        end.to(
          have_enqueued_job(ProfileContext::UpdateUserBroadcastJob).on_queue('broadcast')
        )
      end
    end
  end
end
