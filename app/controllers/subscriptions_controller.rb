# frozen_string_literal: true

# Routes for PayPal Subscriptions
class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create capture]

  def create
    subscription = PayPal::Subscription.create!(params[:plan_id])
    current_user.payments.create(paypal_subscription_id: subscription.id)
    render json: subscription.to_h
  end
end
