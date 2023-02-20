# frozen_string_literal: true

module PayPal
  BASE_URL = 'https://api-m.sandbox.paypal.com'
  # https://developer.paypal.com/api/rest/authentication/
  class Authorization
    def self.access_token
      url = "#{BASE_URL}/v1/oauth2/token"
      response = HTTParty.post(url, {
                                 headers: {
                                   Authorization: "Basic #{basic_auth}"
                                 },
                                 body: 'grant_type=client_credentials'
                               })
      response['access_token']
    end

    def self.basic_auth
      client_id = Rails.application.credentials.dig(:paypal, :client_id)
      secret = Rails.application.credentials.dig(:paypal, :secret)
      Base64.strict_encode64("#{client_id}:#{secret}")
    end

    def self.headers
      {
        'Content-Type': 'application/json',
        Authorization: "Bearer #{access_token}"
      }
    end
  end

  # https://developer.paypal.com/docs/api/orders/v2/
  class Order
    def self.create!
      url = "#{BASE_URL}/v2/checkout/orders"
      handle_response HTTParty.post(url, {
                                      headers: Authorization.headers,
                                      body: payload.to_json
                                    }).body
    end

    def self.capture!(id)
      url = "#{BASE_URL}/v2/checkout/orders/#{id}/capture"
      handle_response HTTParty.post(url, headers: Authorization.headers).body
    end

    # rubocop:disable Metrics/MethodLength
    def self.payload
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

    def self.handle_response(response)
      data = JSON.parse(response)
      response = Struct.new(:id, :status, :links, :payment_source, :purchase_units, :payer, keyword_init: true)
      response.new(data)
    end
  end
end
