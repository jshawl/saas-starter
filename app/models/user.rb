# frozen_string_literal: true

# Users powered by devise
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :payments

  def has_active_subscription?
    payments.subscriptions.active
  end
end
