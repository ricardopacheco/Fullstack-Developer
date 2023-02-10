# frozen_string_literal: true

require 'rails_helper'

describe GuestContext::AuthenticationContract, type: :contract do
  describe '#call' do
    subject(:contract) { described_class.new.call(attributes) }

    context 'when attributes are blank' do
      let(:attributes) { {} }

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:email]).to include(I18n.t('contracts.errors.key?'))
        expect(contract.errors[:password]).to include(I18n.t('contracts.errors.key?'))
      end
    end

    context 'when email attribute has a invalid format' do
      let(:attributes) { attributes_for(:user, email: 'invalid_email') }

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:email]).to include(
          I18n.t('contracts.errors.custom.macro.email_format')
        )
      end
    end

    context 'when password attribute has string length out of range' do
      let(:attributes) { attributes_for(:user, password: 'A') }

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

    context 'when email is not found on database' do
      let(:attributes) { attributes_for(:user, email: 'notfoundemail@provider.net') }

      it 'expect return failure with base error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:base]).to include(I18n.t('devise.failure.invalid', authentication_keys: 'email'))
      end
    end

    context 'when password is invalid' do
      let(:user) { create(:user) }
      let(:attributes) { { email: user.email, password: 'invalidpass' } }

      it 'expect return failure with base error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:base]).to include(I18n.t('devise.failure.invalid', authentication_keys: 'email'))
      end
    end

    context 'when attributes are valid' do
      let(:user) { create(:user) }
      let(:attributes) { { email: user.email, password: 'password' } }

      it 'expect to be success' do
        expect(contract).to be_success
        expect(contract.errors).to be_blank
      end
    end
  end
end
