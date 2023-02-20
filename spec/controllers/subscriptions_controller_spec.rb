# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
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
      post '/subscriptions', params: { plan_id: 'ABC' }
    end.to change { users(:alice).payments.count }.by(1)
    expect(users(:alice).payments.last.paypal_subscription_id).to eq('I-BW452GLLEP1G')
    expect(JSON.parse(response.body)['id']).to eq('I-BW452GLLEP1G')
  end

  it 'shows an existing subscription' do
    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/billing/subscriptions/I-BW452GLLEP1G')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-subscription-get-200.json'))
    users(:alice).payments.create(paypal_subscription_id: 'I-BW452GLLEP1G')
    get '/subscriptions/I-BW452GLLEP1G'
    expect(response.body).to match('I-BW452GLLEP1G')
  end

  it 'confirms the subscription on approve' do
    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/billing/subscriptions/I-BW452GLLEP1G')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-subscription-get-200.json'))
    users(:alice).payments.create(paypal_subscription_id: 'I-BW452GLLEP1G')
    expect(users(:alice).active_subscription?).to be(false)
    post '/subscriptions/I-BW452GLLEP1G/confirm'
    expect(users(:alice).active_subscription?).to be(true)
    expect(response.body).to match('I-BW452GLLEP1G')
  end

  it 'downgrades the subscription on website cancellation'
end
