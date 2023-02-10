# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::DeleteUserOperation, type: :operation do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let(:admin_id) { admin.id }
  let(:user_id) { user.id }

  describe '.call(admin_id, user_id, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        it 'expect result success matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(admin_id, user_id) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure).to be_nil
        end
      end

      context 'when operation happens with failure' do
        it 'expect result matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(admin_id, nil) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure[:base]).to eq(I18n.t('operations.base.profile_not_found'))
        end
      end
    end
  end

  describe '#call(admin_id, user_id)' do
    subject(:operation) { described_class.new.call(admin_id, user_id) }

    context 'when admin_id is not informed or not found on database' do
      let(:admin_id) { nil }
      let(:attributes) { {} }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.admin_not_found'))
      end
    end

    context 'when admin_id is a non-admin user' do
      let(:admin_id) { user_id }
      let(:attributes) { {} }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.user_is_not_admin'))
      end
    end

    context 'when user_id is not informed or not found on database' do
      let(:user_id) { nil }
      let(:attributes) { {} }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.profile_not_found'))
      end
    end

    context 'when attributes are valid' do
      it 'expect operation return success' do
        expect(operation).to be_success
      end

      it 'expect delete user from database' do
        expect { operation }.to change(User.profile, :count).from(1).to(0)
      end

      it 'expect send email to user' do
        expect do
          operation
        end.to(
          have_enqueued_job.on_queue('default').with(
            'AdminContext::UserMailer', 'delete', 'deliver_now', args: [user.email]
          )
        )
      end
    end
  end
end
