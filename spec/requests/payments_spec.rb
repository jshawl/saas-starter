# frozen_string_literal: true

require 'rails_helper'

describe PaymentsController do
  fixtures :users

  before do
    sign_in users(:alice)
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v1/oauth2/token')
      .with(body: 'grant_type=client_credentials')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-oauth-post-200.json'))
  end
  it 'makes a one time purchase' do
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v2/checkout/orders')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-orders-post-200.json'))
    post payments_path
    expect(JSON.parse(response.body)['id']).to eq('4H5S84130W082534H')

    # on approve
    stub_request(:post, 'https://api-m.sandbox.paypal.com/v2/checkout/orders/4H5S84130W082534H/capture')
      .to_return(status: 201, body: File.read('spec/mocks/paypal-orders-capture-post-201.json'))
    expect do
      post payment_capture_path(payment_id: '4H5S84130W082534H')
    end.to change { users(:alice).payments.count }.by(1)
  end
  it 'lists existing payments' do
    get payments_path
    expect(response).to have_http_status(200)
  end
  it 'shows existing payment' do
    stub_request(:get, 'https://api-m.sandbox.paypal.com/v2/checkout/orders/4H5S84130W082534H/capture')
      .to_return(status: 200, body: File.read('spec/mocks/paypal-orders-capture-post-201.json'))
    users(:alice).payments.create(paypal_id: '4H5S84130W082534H', details: '{}')
    get payment_path('4H5S84130W082534H')
    expect(response).to have_http_status(200)
  end
end
