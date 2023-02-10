# frozen_string_literal: true

require 'rails_helper'

describe GuestContext::LoginForm, type: :form do
  subject { described_class.new(params) }

  describe 'when contract invalidate data' do
    let(:params) { { email: 'invalid_email', password: '' } }

    it 'expect to be invalid and add error messages' do
      expect(subject.submit).to be_falsey
      expect(subject.errors[:email]).to include(I18n.t('contracts.errors.custom.macro.email_format'))
      expect(subject.errors[:password]).to include(I18n.t('contracts.errors.key?'))
    end
  end

  describe 'when contract validate data' do
    let(:user) { create(:user) }
    let(:params) { { email: user.email, password: 'password' } }

    it 'expect to be valid and return add error messages' do
      expect(subject.submit).to be_truthy
      expect(subject.user.id).to eq(user.id)
    end
  end
end
