# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::CreateUserContract, type: :contract do
  describe '#call' do
    subject(:contract) { described_class.new.call(attributes) }

    context 'when attributes are blank' do
      let(:attributes) { {} }

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:fullname]).to include(I18n.t('contracts.errors.key?'))
        expect(contract.errors[:email]).to include(I18n.t('contracts.errors.key?'))
      end
    end

    context 'when fullname attribute has string length out of range' do
      let(:attributes) { attributes_for(:user, fullname: 'A') }

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:fullname]).to include(
          I18n.t(
            'contracts.errors.custom.macro.fullname_format',
            min: ApplicationContract::MIN_FULLNAME_LENGTH,
            max: ApplicationContract::MAX_FULLNAME_LENGTH
          )
        )
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

    context 'when email attributes already belong to another user' do
      let(:user) { create(:user) }
      let(:attributes) { attributes_for(:user, email: user.email) }

      it 'expect return failure with error messages' do
        expect(contract).to be_failure
        expect(contract.errors[:email]).to include(I18n.t('errors.messages.taken'))
      end
    end

    context 'when attributes are present and valid' do
      let(:attributes) { attributes_for(:user) }

      it 'expect to be success' do
        expect(contract).to be_success
        expect(contract.errors).to be_blank
      end
    end
  end
end
