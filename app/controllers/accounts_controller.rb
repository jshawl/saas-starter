# frozen_string_literal: true

# Accounts routes
class AccountsController < ApplicationController
  before_action :authenticate_user!
  def show; end

  def purchase
    render json: create_order
  end

  def purchase_capture
    response = paypal_order_capture(params[:id])
    current_user.payments.create!(paypal_id: response["id"], details: response)
    render json: response
  end

  private

  def base_url
    "https://api-m.sandbox.paypal.com"
  end

  def get_access_token
    client_id = Rails.application.credentials.dig(:paypal, :client_id)
    secret = Rails.application.credentials.dig(:paypal, :secret)
    auth = Base64.strict_encode64(client_id + ":" + secret)
    url = "#{base_url}/v1/oauth2/token"
    response = HTTParty.post(url, {
      headers: {
        "Authorization": "Basic #{auth}"
      },
      body: "grant_type=client_credentials",
    })
    response["access_token"]
  end

  def create_order
    url = "#{base_url}/v2/checkout/orders"
    response = HTTParty.post(url, {
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer #{get_access_token}",
      },
      body: ({
        intent: "CAPTURE",
        purchase_units: [
          {
            amount: {
              currency_code: "USD",
              value: "100.00",
            },
          },
        ],
      }).to_json
    }).body
  end

  def paypal_order_capture(id)
    url = "#{base_url}/v2/checkout/orders/#{id}/capture"
    response = JSON.parse(HTTParty.post(url, {
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer #{get_access_token}",
      }
    }).body)
  end
end
