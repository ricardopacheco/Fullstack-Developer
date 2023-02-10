# frozen_string_literal: true

require 'rails_helper'

describe ProfileContext::UpdatePasswordOperation, type: :operation do
  let(:user) { create(:user) }

  describe '.call(user_id, attributes, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      let(:attributes) do
        {
          current_password: 'password',
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      context 'when operation happens with success' do
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
        current_password: 'password',
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    end

    context 'when contract is invalid' do
      let(:user_id) { nil }

      it 'expect return failure with error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.profile_not_found'))
      end
    end

    context 'when model invalidates update' do
      let(:user_model_class) { User }

      before do
        allow(user_model_class).to receive(:find_by).with(id: user.id).and_return(user)
        allow(user).to receive(:update).and_return(false)
        allow(user)
          .to receive(:errors)
          .and_return(
            ActiveModel::Errors.new(user_model_class.new).tap do |e|
              e.add(:password, I18n.t('errors.messages.invalid'))
            end
          )
      end

      it 'expect return failure and return model error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:password]).to include(I18n.t('errors.messages.invalid'))
      end
    end

    context 'when contract is valid' do
      it 'expect operation return success and update password' do
        expect(operation).to be_success
        expect(user.reload).to be_valid_password('new_password')
      end
    end
  end
end
