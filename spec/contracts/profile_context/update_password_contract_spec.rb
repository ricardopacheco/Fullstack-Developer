# frozen_string_literal: true

require 'rails_helper'

describe ProfileContext::UpdatePasswordContract, type: :contract do
  let(:user) { create(:user) }

  describe '#call' do
    subject(:contract) { described_class.new.call(attributes, user: user) }

    context 'when attributes are blank' do
      let(:attributes) { {} }

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:password]).to include(I18n.t('contracts.errors.key?'))
        expect(contract.errors[:password_confirmation]).to include(I18n.t('contracts.errors.key?'))
        expect(contract.errors[:current_password]).to include(I18n.t('contracts.errors.key?'))
      end
    end

    context 'when password attribute has string length out of range' do
      let(:attributes) { { password: 'A' } }

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:password]).to include(
          I18n.t(
            'contracts.errors.custom.macro.password_format',
            min: ApplicationContract::MIN_PASSWORD_LENGTH,
            max: ApplicationContract::MAX_PASSWORD_LENGTH
          )
        )
      end
    end

    context 'when current_password attribute is invalid' do
      let(:attributes) do
        {
          current_password: 'invalidpassw',
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:current_password]).to include(
          I18n.t('errors.messages.invalid')
        )
      end
    end

    context 'when password is not equal to password_confirmation' do
      let(:attributes) do
        {
          current_password: 'password',
          password: 'new_password',
          password_confirmation: 'wrong'
        }
      end

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:password_confirmation]).to include(
          I18n.t('errors.messages.confirmation')
        )
      end
    end

    context 'when attributes are present and valid' do
      let(:attributes) do
        {
          current_password: 'password',
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'expect to be success' do
        expect(contract).to be_success
        expect(contract.errors).to be_blank
      end
    end
  end
end
