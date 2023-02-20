# frozen_string_literal: true

module PayPal
  # https://developer.paypal.com/docs/api/orders/v2/
  class Order
    def self.create!(amount)
      url = "#{BASE_URL}/v2/checkout/orders"
      handle_response HTTParty.post(url, {
                                      headers: PayPal::Authorization.headers,
                                      body: payload(amount).to_json
                                    }).body
    end

    def self.capture!(id)
      url = "#{BASE_URL}/v2/checkout/orders/#{id}/capture"
      handle_response HTTParty.post(url, headers: PayPal::Authorization.headers).body
    end

    def self.payload(amount)
      {
        intent: 'CAPTURE',
        purchase_units: [
          amount
        ]
      }
    end
  end
end
