# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PayPal::Webhook' do
  before do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
      .with(body: 'grant_type=client_credentials')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))
  end
  it 'can create a webhook' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/notifications/webhooks')
      .with(
        body: '{"url":"https://example.com/webhooks","event_types":[{"name":"*"}]}'
      )
      .to_return(status: 201, body: File.read('spec/mocks/paypal-webhooks-post-201.json'))
    PayPal::Webhook.create!(url: 'https://example.com/webhooks')
  end

  it 'can list webhooks' do
    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/notifications/webhooks')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-webhooks-get-200.json'))
    webhooks = PayPal::Webhook.list
    expect(webhooks.webhooks.first['id']).to eq('0EH40505U7160970P')
  end

  it 'can verify incoming webhooks' do
    headers = JSON.parse(File.read('spec/mocks/paypal-webhook-headers.json'))
    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/notifications/webhooks')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-webhooks-get-200.json'))
    webhooks = PayPal::Webhook.list

    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/notifications/verify-webhook-signature')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-webhooks-verify-signature-post-200.json'))

    verification = PayPal::Webhook.verify(
      transmission_id: headers['paypal-transmission-id'],
      transmission_time: headers['paypal-transmission-time'],
      cert_url: headers['paypal-cert-url'],
      auth_algo: headers['paypal-auth-algo'],
      transmission_sig: headers['paypal-transmission-sig'],
      webhook_id: webhooks.webhooks.first['id'],
      webhook_event: JSON.parse(File.read('spec/mocks/paypal-webhook-PAYMENT.SALE.COMPLETED.json'))
    )
    expect(verification.verification_status).to eq('SUCCESS')
  end
end
