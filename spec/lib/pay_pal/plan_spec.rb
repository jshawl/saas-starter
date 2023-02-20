# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PayPal::Plan' do
  it 'can create a plan' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
      .with(body: 'grant_type=client_credentials')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))

    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/billing/plans')
      .with({ body: /PROD-XYAB12ABSB7868434/ })
      .to_return(status: 201, body: File.read('spec/mocks/paypal-plans-post-201.json'))
    PayPal::Plan.create!(product_id: 'PROD-XYAB12ABSB7868434', name: 'plan name', description: 'plan description')
  end
end
