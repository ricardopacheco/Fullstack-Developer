# frozen_string_literal: true

require 'rails_helper'

describe GuestContext::CreatePasswordOperation, type: :operation do
  let(:user) { create(:user, :with_token) }
  let(:attributes) do
    {
      token: user.token,
      password: 'newpassword',
      password_confirmation: 'newpassword'
    }
  end

  describe '.call(attributes, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        it 'expect result success matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(attributes) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_a(User)
          expect(matched_failure).to be_nil
        end
      end

      context 'when operation happens with failure' do
        let(:attributes) do
          {
            token: 'invalidtoken',
            password: 'newpassword',
            password_confirmation: 'newpassword'
          }
        end

        it 'expect result matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(attributes) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure[:base]).to include(I18n.t('errors.messages.token_not_found'))
        end
      end
    end
  end

  describe '#call(attributes)' do
    subject(:operation) { described_class.new.call(attributes) }

    context 'when token is empty or not found' do
      let(:attributes) { {} }

      it 'expect return failure with error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:token]).to include(I18n.t('contracts.errors.key?'))
        expect(operation.failure[:password]).to include(I18n.t('contracts.errors.key?'))
        expect(operation.failure[:password_confirmation]).to include(I18n.t('contracts.errors.key?'))
      end
    end

    context 'when model invalidate operation' do
      let(:user_model_class) { User }

      before do
        allow(user_model_class).to receive(:find_by).and_return(user)
        allow(user).to receive(:update).with(password: attributes[:password]).and_return(true)
        allow(user).to receive(:update).with(token: nil).and_return(false)
        allow(user)
          .to receive(:errors)
          .and_return(
            ActiveModel::Errors.new(user_model_class.new).tap do |e|
              e.add(:token, I18n.t('errors.messages.invalid'))
            end
          )
      end

      it 'expect return failure and return model error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:token]).to include(I18n.t('errors.messages.invalid'))
      end
    end

    context 'when attributes are valid' do
      it 'expect operation return success' do
        expect(operation).to be_success
        expect(operation.success.email).to eq(user.email)
      end
    end
  end
end
