# frozen_string_literal: true

module PayPal
  # https://developer.paypal.com/docs/api/subscriptions/v2/
  class Subscription
    def self.create!(plan_id)
      url = "#{BASE_URL}/v1/billing/subscriptions"
      PayPal.handle_response HTTParty.post(url, {
                                             headers: PayPal::Authorization.headers,
                                             body:
                                             { plan_id:,
                                               application_context: {
                                                 shipping_preference: 'NO_SHIPPING'
                                               } }.to_json
                                           }).body
    end

    def self.find(id)
      url = "#{BASE_URL}/v1/billing/subscriptions/#{id}"
      PayPal.handle_response HTTParty.get(url, {
                                            headers: PayPal::Authorization.headers
                                          }).body
    end
  end
end
