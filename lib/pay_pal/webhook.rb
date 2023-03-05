# frozen_string_literal: true

module PayPal
  # https://developer.paypal.com/docs/api/webhooks/v1/
  class Webhook
    def self.create!(opts)
      url = "#{BASE_URL}/v1/notifications/webhooks"
      PayPal.handle_response HTTParty.post(url, {
                                             headers: PayPal::Authorization.headers,
                                             body:
                                             { url: opts[:url],
                                               event_types: [{
                                                 name: '*'
                                               }] }.to_json
                                           }).body
    end

    def self.list
      url = "#{BASE_URL}/v1/notifications/webhooks"
      PayPal.handle_response HTTParty.get(url, {
                                            headers: PayPal::Authorization.headers
                                          }).body
    end

    def self.verify(opts)
      url = "#{BASE_URL}/v1/notifications/verify-webhook-signature"
      PayPal.handle_response HTTParty.post(url, {
                                             headers: PayPal::Authorization.headers,
                                             body: opts.to_json
                                           }).body
    end
  end
end
