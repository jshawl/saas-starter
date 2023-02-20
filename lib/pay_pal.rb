# frozen_string_literal: true

# https://developer.paypal.com/api/rest/
module PayPal
  BASE_URL = Rails.env.production? ? 'https://api-m.paypal.com' : 'https://api-m.sandbox.paypal.com'
  def self.handle_response(response)
    data = JSON.parse(response)
    # rubocop:disable Style/OpenStructUse
    OpenStruct.new(data)
    # rubocop:enable Style/OpenStructUse
  end
end
