# frozen_string_literal: true

require 'rails_helper'

describe GuestContext::AuthenticationOperation, type: :operation do
  let(:user) { create(:user) }

  describe '.call(attributes, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        let(:attributes) { { email: user.email, password: 'password' } }

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
        let(:attributes) { {} }

        it 'expect result matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(attributes) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure[:email]).to include(I18n.t('contracts.errors.key?'))
        end
      end
    end
  end

  describe '#call(attributes)' do
    subject(:operation) { described_class.new.call(attributes) }

    context 'when contract is invalid' do
      let(:attributes) { {} }

      it 'expect return failure with error messages' do
        expect(operation).to be_failure
        expect(operation.failure[:email]).to include(I18n.t('contracts.errors.key?'))
        expect(operation.failure[:password]).to include(I18n.t('contracts.errors.key?'))
      end
    end

    context 'when attributes are valid' do
      let(:attributes) { { email: user.email, password: 'password' } }

      it 'expect operation return success' do
        expect(operation).to be_success
        expect(operation.success.email).to eq(user.email)
      end
    end
  end
end
