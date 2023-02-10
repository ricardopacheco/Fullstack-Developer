# frozen_string_literal: true

require 'rails_helper'

describe GuestContext::RegistrationForm, type: :form do
  subject { described_class.new(params) }

  describe 'when contract invalidate data' do
    let(:params) { {} }

    it 'expect to be invalid and add error messages' do
      expect(subject.submit).to be_falsey
      expect(subject.errors[:email]).to include(I18n.t('contracts.errors.key?'))
      expect(subject.errors[:fullname]).to include(I18n.t('contracts.errors.key?'))
      expect(subject.errors[:password]).to include(I18n.t('contracts.errors.key?'))
      expect(subject.errors[:password_confirmation]).to include(I18n.t('contracts.errors.key?'))
    end
  end

  describe 'when contract validate data' do
    let(:params) { attributes_for(:user) }

    it 'expect to be valid and return persisted user' do
      expect(subject.submit).to be_truthy
      expect(subject.user).to be_a(User)
      expect(subject.user.id).to be_present
    end
  end
end
