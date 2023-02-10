# frozen_string_literal: true

module AdminContext
  # THis class is used to send emails to users through operations performed
  # by admins.
  class UserMailer < ApplicationMailer
    def welcome(user)
      @user = user

      mail(to: @user.email, subject: default_i18n_subject(fullname: @user.fullname))
    end

    def delete(email)
      mail(to: email, subject: default_i18n_subject)
    end
  end
end
