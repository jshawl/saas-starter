# frozen_string_literal: true

# Users powered by devise
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :identities, dependent: :delete_all
  has_many :payments

  after_create :send_welcome_email
  after_create :create_contact, if: :marketing_opted_in?

  def active_subscription
    payments.subscriptions.active.to_a.first
  end

  def active_subscription?
    !!active_subscription
  end

  def service_account?
    !!(email.match Rails.application.config.domain)
  end

  def self.create_from_omniauth!(auth_info)
    uid = auth_info['uid']
    email = auth_info['info']['email'] || "#{SecureRandom.uuid}@#{Rails.application.config.domain}"
    password = SecureRandom.uuid
    find_by_uid(uid) || create!(email:, password:, uid:)
  end

  private

  def send_welcome_email
    return if service_account?

    UserMailer.with(user: self).welcome.deliver_now!
  end

  def create_contact
    sg = SendGrid::API.new(api_key: Rails.application.credentials.dig(:sendgrid))
    data = {
      contacts: [
        {email:}
      ]
    }
    sg.client.marketing.contacts.put(request_body: data)
  end
end
