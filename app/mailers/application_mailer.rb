# frozen_string_literal: true

# This class provides the default config for application can send emails.
class ApplicationMailer < ActionMailer::Base
  append_view_path Rails.root.join('app/views/mailers')
  default from: 'from@example.com'
  layout 'mailer'
end
