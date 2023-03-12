# frozen_string_literal: true

# Base Mailer
class ApplicationMailer < ActionMailer::Base
  default from: "mailer@#{Rails.application.config.domain}"
  layout 'mailer'
end
