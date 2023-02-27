# frozen_string_literal: true

# Base Mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'mailer@saas-starter.app'
  layout 'mailer'
end
