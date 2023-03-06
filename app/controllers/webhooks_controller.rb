# frozen_string_literal: true

# Process incoming webhooks
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]

  def create
    verify_webhook_signature!

    if params['event_type'] == 'BILLING.SUBSCRIPTION.CANCELLED'
      payment = Payment.find_by_paypal_subscription_id(params['resource']['id'])
      payment.update!(details: params['resource'])
    end
    head 200
  end

  private

  def verify_webhook_signature!
    webhooks = PayPal::Webhook.list
    verification = PayPal::Webhook.verify(
      verification_params_from_headers.merge(
        webhook_id: webhooks.webhooks.first['id'],
        webhook_event: params.except(:action, :controller)
      )
    )
    return unless verification.verification_status != 'SUCCESS'

    raise 'Webhook verification failed!'
  end

  def verification_params_from_headers
    {
      transmission_id: request.headers['paypal-transmission-id'],
      transmission_time: request.headers['paypal-transmission-time'],
      cert_url: request.headers['paypal-cert-url'],
      auth_algo: request.headers['paypal-auth-algo'],
      transmission_sig: request.headers['paypal-transmission-sig']
    }
  end
end
