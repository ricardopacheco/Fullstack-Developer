# frozen_string_literal: true

require 'rails_helper'

describe ProfileContext::CreateProfileUserOperation, type: :operation do
  describe '.call(attributes, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        let(:attributes) { attributes_for(:user) }

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
          expect(matched_failure[:fullname]).to include(I18n.t('contracts.errors.key?'))
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
        expect(operation.failure[:fullname]).to include(I18n.t('contracts.errors.key?'))
      end
    end

    context 'when model invalidate any attribute' do
      let(:user) { build(:user) }
      let(:user_model_class) { User }
      let(:attributes) { attributes_for(:user) }

      before do
        allow(user_model_class).to receive(:new).and_call_original
        allow(user_model_class).to receive(:new).and_return(user)
        allow(user).to receive(:save).and_return(false)
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
      let(:attributes) { attributes_for(:user) }

      it 'expect operation return success' do
        expect(operation).to be_success
      end

      it 'expect create a new profile user in database' do
        expect { operation }.to change(User.profile, :count).from(0).to(1)
      end
    end
  end
end
