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
  it 'can list plans' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
    .with(body: 'grant_type=client_credentials')
    .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))

    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/billing/plans')
    .to_return(status: 201, body: File.read('spec/mocks/paypal-plans-get-200.json'))
    PayPal::Plan.list
  end
  it 'can find a plans' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
    .with(body: 'grant_type=client_credentials')
    .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))

    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/billing/plans/P-5ML4271244454362WXNWU5NQ')
    .to_return(status: 201, body: File.read('spec/mocks/paypal-plan-get-200.json'))
    PayPal::Plan.find('P-5ML4271244454362WXNWU5NQ')
  end
end
