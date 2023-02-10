# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::UpdateUserOperation, type: :operation do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:admin_id) { admin.id }
  let(:user_id) { user.id }

  describe '.call(admin_id, user_id, attributes, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        let(:attributes) { attributes_for(:user).slice(:email, :fullname) }

        it 'expect result success matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(admin_id, user_id, attributes) do |o|
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

          operation.call(admin_id, user_id, attributes) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure[:email]).to include(
            I18n.t('contracts.errors.custom.macro.email_format')
          )
        end
      end
    end
  end

  describe '#call(admin_id, user_id, attributes)' do
    subject(:operation) { described_class.new.call(admin_id, user_id, attributes) }

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
      let(:attributes) { attributes_for(:user).slice(:email, :fullname) }
      let(:admin_model_class) { User }

      before do
        allow(admin_model_class).to receive(:find_by).with(id: admin_id).and_return(admin)
        allow(admin_model_class).to receive(:find_by).with(id: user_id).and_return(user)
        allow(user).to receive(:update).and_return(false)
        allow(user)
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
      let(:attributes) { attributes_for(:user).slice(:email, :fullname) }

      it 'expect operation return success' do
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
    end
  end
end
