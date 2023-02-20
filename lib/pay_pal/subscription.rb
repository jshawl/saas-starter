# frozen_string_literal: true

module PayPal
  # https://developer.paypal.com/docs/api/subscriptions/v2/
  class Subscription
    def self.create!(plan_id)
      url = "#{BASE_URL}/v1/billing/subscriptions"
      PayPal.handle_response HTTParty.post(url, {
                                             headers: PayPal::Authorization.headers,
                                             body:
                                             { plan_id: }.to_json
                                           }).body
    end
  end
end
