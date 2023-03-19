# frozen_string_literal: true

# Users powered by devise
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :identities
  has_many :payments

  after_create :send_welcome_email

  def active_subscription
    payments.subscriptions.active.to_a.first
  end

  def active_subscription?
    !!active_subscription
  end

  def self.create_from_omniauth!(auth_info)
    uid = auth_info['uid']
    email = auth_info['info']['email'] || "#{SecureRandom.uuid}@#{Rails.application.config.domain}"
    password = SecureRandom.uuid
    find_by_uid(uid) || create!(email:, password:, uid:)
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now!
  end
end
