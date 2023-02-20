# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PayPal::Product' do
  it 'can create a plan' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
      .with(body: 'grant_type=client_credentials')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/catalogs/products')
      .to_return(status: 201, body: File.read('spec/mocks/paypal-products-post-201.json'))
    PayPal::Product.create!(name: 'Product Name', description: 'Product description')
  end
end
