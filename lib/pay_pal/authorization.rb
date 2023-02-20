# frozen_string_literal: true

module PayPal
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
end
