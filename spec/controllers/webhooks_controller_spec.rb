# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Webhooks', type: :request do
  fixtures :users

  before do
    @payment = users(:alice).payments.create!(
      paypal_subscription_id: 'I-BW452GLLEP1G',
      details: {
        status: 'ACTIVE'
      }
    )
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
      .with(body: 'grant_type=client_credentials')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))

    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/notifications/webhooks')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-webhooks-get-200.json'))
  end
  it 'processes incoming webhooks' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/notifications/verify-webhook-signature')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-webhooks-verify-signature-post-200.json'))

    payload = File.read('spec/mocks/paypal-webhook-BILLING.SUBSCRIPTION.CANCELLED.json')
    post '/webhooks', headers: {
        'Content-Type': 'application/json'
    }, params: payload
    expect(JSON.parse(payload)["resource"]["status"]).to eq("CANCELLED")
    expect(Payment.last.details["status"]).to eq('CANCELLED')
  end

  it 'ignores unverified webhook signatures' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/notifications/verify-webhook-signature')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-webhooks-verify-signature-failure-post-200.json'))

    post '/webhooks', headers: {
      'Content-Type': 'application/json'
    }, params: File.read('spec/mocks/paypal-webhook-BILLING.SUBSCRIPTION.CANCELLED.json')
    expect(users(:alice).payments.last.details['status']).to eq('ACTIVE')
  end
end
