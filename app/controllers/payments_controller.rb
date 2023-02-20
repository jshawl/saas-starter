# frozen_string_literal: true

# Payments
class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create capture]
  before_action :authenticate_user!

  def create
    render json: create_order
  end

  def capture
    response = paypal_order_capture(params[:payment_id])
    current_user.payments.create!(paypal_id: JSON.parse(response)['id'], details: response)
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
    'https://api-m.sandbox.paypal.com'
  end

  def access_token
    url = "#{base_url}/v1/oauth2/token"
    response = HTTParty.post(url, {
                               headers: {
                                 Authorization: "Basic #{basic_auth}"
                               },
                               body: 'grant_type=client_credentials'
                             })
    response['access_token']
  end

  def basic_auth
    client_id = Rails.application.credentials.dig(:paypal, :client_id)
    secret = Rails.application.credentials.dig(:paypal, :secret)
    Base64.strict_encode64("#{client_id}:#{secret}")
  end

  # rubocop:disable Metrics/MethodLength
  def payload
    {
      intent: 'CAPTURE',
      purchase_units: [
        {
          amount: {
            currency_code: 'USD',
            value: '0.01'
          }
        }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength

  def create_order
    url = "#{base_url}/v2/checkout/orders"
    HTTParty.post(url, {
                    headers: {
                      'Content-Type': 'application/json',
                      Authorization: "Bearer #{access_token}"
                    },
                    body: payload.to_json
                  }).body
  end

  def paypal_order_capture(id)
    url = "#{base_url}/v2/checkout/orders/#{id}/capture"
    HTTParty.post(url, {
                    headers: {
                      'Content-Type': 'application/json',
                      Authorization: "Bearer #{access_token}"
                    }
                  }).body
  end
end
