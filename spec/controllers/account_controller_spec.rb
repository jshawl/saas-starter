# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Account", type: :request do
  fixtures :users
  it "makes a one time purchase" do
    sign_in users(:alice)
    stub_request(:post, "https://api-m.sandbox.paypal.com/v1/oauth2/token").
      with(body: "grant_type=client_credentials").
      to_return(status: 200, body: File.read("spec/mocks/paypal-oauth-post-200.json"))
    stub_request(:post, "https://api-m.sandbox.paypal.com/v2/checkout/orders").
      to_return(status: 200, body: File.read("spec/mocks/paypal-orders-post-200.json"))
    post "/account/purchase"
    expect(JSON.parse(response.body)["id"]).to eq("4H5S84130W082534H")

    # on approve
    stub_request(:post, "https://api-m.sandbox.paypal.com/v2/checkout/orders/4H5S84130W082534H/capture").
    to_return(status: 201, body: File.read("spec/mocks/paypal-orders-capture-post-201.json"))
    expect{
      post("/account/purchase-capture", params: { id: "4H5S84130W082534H" })
    }.to change{users(:alice).payments.count}.by(1)
  end
end
