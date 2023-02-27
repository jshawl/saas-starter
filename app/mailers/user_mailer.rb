# frozen_string_literal: true

# Transactional emails for Users
class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to SaaS Starter!')
  end
end
