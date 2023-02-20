# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  fixtures :users
  it 'creates a subscription' do
    sign_in users(:alice)
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
      .with(body: 'grant_type=client_credentials')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/billing/subscriptions')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-subscriptions-post-201.json'))
    expect do
      post '/subscriptions', params: { plan_id: 'ABC' }
    end.to change { users(:alice).payments.count }.by(1)
    expect(users(:alice).payments.last.paypal_subscription_id).to eq('I-BW452GLLEP1G')
    expect(JSON.parse(response.body)['id']).to eq('I-BW452GLLEP1G')
  end
end
