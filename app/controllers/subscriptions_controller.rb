# frozen_string_literal: true

# Routes for PayPal Subscriptions
class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create capture confirm]

  def create
    subscription = PayPal::Subscription.create!(params[:plan_id])
    current_user.payments.create(paypal_subscription_id: subscription.id)
    render json: subscription.to_h
  end

  def confirm
    payment = current_user.payments.find_by_paypal_subscription_id(params[:subscription_id])
    subscription = PayPal::Subscription.find(params[:subscription_id])
    payment.update(details: subscription.to_h)
    flash[:notice] = 'Subscription created successfully!'
    render json: subscription
  end

  def show
    @subscription = Rails.cache.fetch("subscription-#{params[:id]}", expires_in: 10.minutes) do
      PayPal::Subscription.find(params[:id])
    end
  end
end
