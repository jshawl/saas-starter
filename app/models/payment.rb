# frozen_string_literal: true

# Payment Model
class Payment < ApplicationRecord
  belongs_to :user
  scope :orders, -> { where(paypal_subscription_id: nil) }
  scope :subscriptions, -> { where.not(paypal_subscription_id: nil) }
  scope :active, -> {where("details ->> 'status' = 'ACTIVE'").any?}
end
