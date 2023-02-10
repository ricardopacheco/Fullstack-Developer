# frozen_string_literal: true

require 'rails_helper'

describe ProfileContext::UpdateFieldsForm, type: :form do
  subject { described_class.new(params) }

  let(:user) { create(:user) }

  describe 'when contract invalidate data' do
    let(:params) { { fullname: 'A', email: 'invalid' } }

    it 'expect to be invalid and add error messages' do
      expect(subject.submit(user.id)).to be_falsey
      expect(subject.errors[:email]).to include(
        I18n.t('contracts.errors.custom.macro.email_format')
      )
      expect(subject.errors[:fullname]).to include(
        I18n.t(
          'contracts.errors.custom.macro.fullname_format',
          min: ApplicationContract::MIN_FULLNAME_LENGTH,
          max: ApplicationContract::MAX_FULLNAME_LENGTH
        )
      )
    end
  end

  describe 'when contract validate data' do
    let(:params) { { fullname: 'New Fullname', email: 'newemail@provider.net' } }

    it 'expect to be valid and return user with updated data' do
      expect(subject.submit(user.id)).to be_truthy
      expect(subject.user.fullname).to eq(params[:fullname])
      expect(subject.user.email).to eq(params[:email])
    end
  end
end
