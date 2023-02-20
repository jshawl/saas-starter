# frozen_string_literal: true

# Payments
class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create capture]
  before_action :authenticate_user!

  def create
    render json: PayPal::Order.create!(amount: { currency_code: 'USD', value: '1.23' }).to_h
  end

  def capture
    order = PayPal::Order.capture!(params[:payment_id])
    current_user.payments.create!(paypal_id: order.id, details: order.to_h)
    render json: order
  end

  def index
    @payments = current_user.payments.orders
    @subscriptions = current_user.payments.subscriptions
  end

  def show
    @payment = current_user.payments.find_by_paypal_id(params[:id])
  end
end
