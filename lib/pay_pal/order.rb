# frozen_string_literal: true

module PayPal
  # https://developer.paypal.com/docs/api/orders/v2/
  class Order
    def self.create!(amount)
      url = "#{BASE_URL}/v2/checkout/orders"
      PayPal.handle_response HTTParty.post(url, {
                                             headers: PayPal::Authorization.headers,
                                             body: payload(amount).to_json
                                           }).body
    end

    def self.capture!(id)
      url = "#{BASE_URL}/v2/checkout/orders/#{id}/capture"
      PayPal.handle_response HTTParty.post(url, headers: PayPal::Authorization.headers).body
    end

    # rubocop:disable Metrics/MethodLength
    def self.payload(amount)
      {
        intent: 'CAPTURE',
        purchase_units: [
          amount
        ],
        payment_source: {
          paypal: {
            experience_context: {
              shipping_preference: 'NO_SHIPPING'
            }
          }
        }
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end
