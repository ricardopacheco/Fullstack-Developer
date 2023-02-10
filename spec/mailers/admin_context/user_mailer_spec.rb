# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::UserMailer do
  let(:user) { create(:user) }

  describe '#welcome(user)' do
    it 'expect to send email to user' do
      mail = described_class.welcome(user)
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(
        I18n.t('admin_context.user_mailer.welcome.subject', fullname: user.fullname)
      )
    end
  end

  describe '#delete(email)' do
    it 'expect to send email to user' do
      mail = described_class.delete(user.email)
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(I18n.t('admin_context.user_mailer.delete.subject'))
    end
  end
end
