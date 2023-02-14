# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::CreateUserOperation, type: :operation do
  let(:admin_user) { create(:user, :admin) }
  let(:profile_user) { create(:user) }
  let(:admin_user_id) { admin_user.id }
  let(:profile_user_id) { profile_user.id }

  describe '.call(admin_id, attributes, &block)' do
    let(:operation) { described_class }
    let(:admin_id) { admin_user_id }

    context 'when block is given' do
      context 'when operation happens with success' do
        let(:attributes) { attributes_for(:user) }

        it 'expect result success matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(admin_id, attributes) do |o|
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

          operation.call(admin_id, attributes) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure[:fullname]).to include(I18n.t('contracts.errors.key?'))
        end
      end
    end
  end

  describe '#call(admin_id, attributes)' do
    subject(:operation) { described_class.new.call(admin_id, attributes) }

    context 'when admin_id is not informed or not found on database' do
      let(:admin_id) { nil }
      let(:attributes) { {} }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.admin_not_found'))
      end
    end

    context 'when admin_id is a non-admin user' do
      let(:admin_id) { profile_user_id }
      let(:attributes) { {} }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.user_is_not_admin'))
      end
    end

    context 'when contract is invalid' do
      let(:admin_id) { admin_user_id }
      let(:attributes) { {} }

      it 'expect return failure with error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:fullname]).to include(I18n.t('contracts.errors.key?'))
      end
    end

    context 'when model invalidate any attribute' do
      let!(:invalid_admin_model_user) { build(:user, email: 'example@email.net') }
      let!(:admin_id) { admin_user_id }
      let(:attributes) { invalid_admin_model_user.attributes.slice('email', 'fullname') }
      let(:admin_model_class) { User }

      before do
        allow(admin_model_class).to receive(:new).and_call_original
        allow(admin_model_class).to receive(:new).and_return(invalid_admin_model_user)
        allow(invalid_admin_model_user).to receive(:save).and_return(false)
        allow(invalid_admin_model_user)
          .to receive(:errors)
          .and_return(
            ActiveModel::Errors.new(admin_model_class.new).tap do |e|
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
      let(:admin_id) { admin_user_id }
      let(:attributes) { attributes_for(:user) }

      it 'expect operation return success' do
        expect(operation).to be_success
      end

      it 'expect create a new admin user in database' do
        expect { operation }.to change(User.admin, :count).from(0).to(1)
      end

      it 'expect send email to user' do
        expect do
          operation
        end.to(
          have_enqueued_job.on_queue('default').with(
            'AdminContext::UserMailer', 'welcome', 'deliver_now', args: [User]
          )
        )
      end

      it 'expect send broadcast event' do
        expect do
          operation
        end.to(
          have_enqueued_job(AdminContext::CreateUserBroadcastJob).on_queue('broadcast')
        )
      end
    end
  end
end
