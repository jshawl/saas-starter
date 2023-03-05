# frozen_string_literal: true

# routes that don't require authentication
class PublicController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[webhooks]

  include Pricing
  def index; end

  def pricing
    @plans = build_plans_list
  end

  def webhooks
    if params["event_type"] == "BILLING.SUBSCRIPTION.CANCELLED"
      paypal_subscription_id = params["resource"]["id"]
      payment = Payment.find_by_paypal_subscription_id(params["resource"]["id"])
      # todo verify signature
      # https://developer.paypal.com/docs/api/webhooks/v1/#verify-webhook-signature_post
      payment.update(details: params["resource"])
    end
    head 200
  end
end
