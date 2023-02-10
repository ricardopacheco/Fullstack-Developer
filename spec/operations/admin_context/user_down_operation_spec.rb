# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::UserDownOperation, type: :operation do
  let(:admin) { create(:user, :admin) }
  let(:admin_user) { create(:user, :admin) }
  let(:admin_id) { admin.id }
  let(:admin_user_id) { admin_user.id }

  describe '.call(admin_id, user_id, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        it 'expect result success matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(admin_id, admin_user_id) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_a(User)
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

  describe '#call(admin_id, admin_user_id)' do
    subject(:operation) { described_class.call(admin_id, admin_user_id) }

    context 'when admin_id is not informed or not found on database' do
      let(:admin_id) { nil }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.admin_not_found'))
      end
    end

    context 'when admin_id is a non-admin user' do
      before do
        allow(User).to receive(:find_by).with(id: admin.id).and_return(admin)
        allow(admin).to receive(:admin?).and_return(false)
      end

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.user_is_not_admin'))
      end
    end

    context 'when admin_user_id is not informed or not found on database' do
      let(:admin_user_id) { nil }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.profile_not_found'))
      end
    end

    context 'when admin_user_id is already not a admin user' do
      before do
        admin_user.update(role: :profile)
        admin_user.reload
      end

      it 'expect return success and nothing more' do
        expect(operation).to be_success
      end
    end

    context 'when admin_id is equal to user_id' do
      let(:admin_user_id) { admin_id }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.myself'))
      end
    end

    context 'when model invalidate operation' do
      let(:admin_model_class) { User }

      before do
        allow(admin_model_class).to receive(:find_by).with(id: admin.id).and_return(admin)
        allow(admin_model_class).to receive(:find_by).with(id: admin_user.id).and_return(admin_user)
        allow(admin_user).to receive(:profile!).and_return(false)
        allow(admin_user)
          .to receive(:errors)
          .and_return(
            ActiveModel::Errors.new(admin_model_class.new).tap do |e|
              e.add(:role, I18n.t('errors.messages.invalid'))
            end
          )
      end

      it 'expect return failure and return model error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(
          I18n.t('operations.admin_context.user_down_operation.error')
        )
      end
    end

    context 'when attributes are valid' do
      it 'expect operation return success' do
        expect(operation).to be_success
      end

      it 'expect convert admin_user in user profile' do
        expect { operation }.to change { admin_user.reload.profile? }.from(false).to(true)
      end
    end
  end
end
