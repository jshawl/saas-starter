# frozen_string_literal: true

# Users powered by devise
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :payments

  after_create :send_welcome_email

  def active_subscription?
    payments.subscriptions.active.any?
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now!
  end
end
