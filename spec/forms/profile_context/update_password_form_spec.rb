# frozen_string_literal: true

require 'rails_helper'

describe ProfileContext::UpdatePasswordForm, type: :form do
  subject { described_class.new(params) }

  let(:user) { create(:user) }

  describe 'when contract invalidate data' do
    let(:params) { {} }

    it 'expect to be invalid and add error messages' do
      expect(subject.submit(user.id)).to be_falsey
      expect(subject.errors[:current_password]).to include(I18n.t('contracts.errors.key?'))
      expect(subject.errors[:password]).to include(I18n.t('contracts.errors.key?'))
      expect(subject.errors[:password_confirmation]).to include(I18n.t('contracts.errors.key?'))
    end
  end

  describe 'when contract validate data' do
    let(:params) do
      {
        current_password: 'password',
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    end

    it 'expect to be valid and return user with updated password' do
      expect(subject.submit(user.id)).to be_truthy
      expect(subject.user).to eq(user)
      expect(subject.user.reload).to be_valid_password(params[:password])
    end
  end
end
