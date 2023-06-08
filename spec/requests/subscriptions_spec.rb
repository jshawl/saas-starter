# frozen_string_literal: true

require 'rails_helper'

describe SubscriptionsController do
  fixtures :users

  before do
    sign_in users(:alice)
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
      .with(body: 'grant_type=client_credentials')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))
  end
  it 'creates a subscription' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/billing/subscriptions')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-subscriptions-post-201.json'))
    expect do
      post subscriptions_path(plan_id: 'ABC')
    end.to change { users(:alice).payments.count }.by(1)
    expect(users(:alice).payments.last.paypal_subscription_id).to eq('I-BW452GLLEP1G')
    expect(response).to have_http_status(200)
  end

  it 'shows an existing subscription' do
    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/billing/subscriptions/I-BW452GLLEP1G')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-subscription-get-200.json'))
    users(:alice).payments.create(paypal_subscription_id: 'I-BW452GLLEP1G')
    get subscription_path('I-BW452GLLEP1G')
    expect(response).to have_http_status(200)
  end

  it 'confirms the subscription on approve' do
    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/billing/subscriptions/I-BW452GLLEP1G')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-subscription-get-200.json'))
    users(:alice).payments.create(paypal_subscription_id: 'I-BW452GLLEP1G')
    expect(users(:alice).active_subscription?).to be(false)
    post subscription_confirm_path(subscription_id: 'I-BW452GLLEP1G')
    expect(users(:alice).active_subscription?).to be(true)
    expect(response).to have_http_status(200)
  end
end
