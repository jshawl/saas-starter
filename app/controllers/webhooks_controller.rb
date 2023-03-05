# frozen_string_literal: true

# Process incoming webhooks
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]

  def create
    webhooks = PayPal::Webhook.list
    verification = PayPal::Webhook.verify(
      transmission_id: request.headers['paypal-transmission-id'],
      transmission_time: request.headers['paypal-transmission-time'],
      cert_url: request.headers['paypal-cert-url'],
      auth_algo: request.headers['paypal-auth-algo'],
      transmission_sig: request.headers['paypal-transmission-sig'],
      webhook_id: webhooks.webhooks.first['id'],
      webhook_event: params.except(:action, :controller)
    )
    if verification.verification_status != 'SUCCESS'
      logger.warn 'Webhook verification failed. Refusing to process webhook'
      return head 200
    end

    if params['event_type'] == 'BILLING.SUBSCRIPTION.CANCELLED'
      payment = Payment.find_by_paypal_subscription_id(params['resource']['id'])
      payment.update(details: params['resource'])
    end
    head 200
  end
end
