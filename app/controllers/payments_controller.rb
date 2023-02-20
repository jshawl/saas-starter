class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :capture]
  before_action :authenticate_user!

  def create
    render json: create_order
  end
  def capture
    response = paypal_order_capture(params[:payment_id])
    current_user.payments.create!(paypal_id: JSON.parse(response)["id"], details: response)
    render json: response
  end
  def index
    @payments = current_user.payments
  end
  def show
    @payment = current_user.payments.find_by_paypal_id(params[:id])
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
              value: "0.01",
            },
          },
        ],
      }).to_json
    }).body
  end

  def paypal_order_capture(id)
    url = "#{base_url}/v2/checkout/orders/#{id}/capture"
    response = HTTParty.post(url, {
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer #{get_access_token}",
      }
    }).body
  end
end
