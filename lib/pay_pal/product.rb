# frozen_string_literal: true

module PayPal
  # https://developer.paypal.com/docs/api/catalog-products/v1/
  class Product
    def self.create!(opts)
      url = "#{BASE_URL}/v1/catalogs/products"
      PayPal.handle_response HTTParty.post(url, {
                                             headers: PayPal::Authorization.headers,
                                             body: payload(opts).to_json
                                           }).body
    end

    def self.payload(opts)
      {
        name: opts[:name],
        description: opts[:description],
        type: 'SERVICE',
        category: 'SOFTWARE',
        image_url: 'https://example.com/streaming.jpg',
        home_url: 'https://example.com/home'
      }
    end
  end
end
