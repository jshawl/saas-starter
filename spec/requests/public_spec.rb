# frozen_string_literal: true

require 'rails_helper'

describe PublicController do
  it 'has a pricing page' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
      .to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'https://api-m.sandbox.paypal.com/v1/billing/plans')
      .to_return(status: 200, body: File.read("spec/mocks/paypal-plans-get-200.json"), headers: {})
    stub_request(:get, /https:\/\/api-m.sandbox.paypal.com\/v1\/billing\/plans\/(.*)/)
      .to_return(status: 200, body: File.read("spec/mocks/paypal-plan-get-200.json"), headers: {})
    get pricing_path
    expect(response).to have_http_status(200)
  end
end
