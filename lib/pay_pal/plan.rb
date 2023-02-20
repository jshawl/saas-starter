# frozen_string_literal: true

module PayPal
  # https://developer.paypal.com/docs/api/subscriptions/v1/
  class Plan
    # https://developer.paypal.com/docs/api/subscriptions/v1/#plans_create
    def self.create!(opts)
      url = "#{BASE_URL}/v1/billing/plans"
      PayPal.handle_response HTTParty.post(url, {
                                             headers: PayPal::Authorization.headers,
                                             body: payload(opts).to_json
                                           }).body
    end

    def self.list
      url = "#{BASE_URL}/v1/billing/plans"
      PayPal.handle_response HTTParty.get(url, {
                                            headers: PayPal::Authorization.headers
                                          }).body
    end

    def self.find(product_id)
      url = "#{BASE_URL}/v1/billing/plans/#{product_id}"
      PayPal.handle_response HTTParty.get(url, {
                                            headers: PayPal::Authorization.headers
                                          }).body
    end

    # rubocop:disable Metrics/MethodLength
    def self.payload(opts)
      { product_id: opts[:product_id],
        name: opts[:name],
        description: opts[:description],
        status: 'ACTIVE',
        billing_cycles: [
          {
            frequency: {
              interval_unit: 'MONTH',
              interval_count: 1
            },
            tenure_type: 'REGULAR',
            sequence: 1,
            total_cycles: 12,
            pricing_scheme: {
              fixed_price: {
                value: '1',
                currency_code: 'USD'
              }
            }
          }
        ],
        payment_preferences: {
          auto_bill_outstanding: true,
          payment_failure_threshold: 3
        } }
    end
    # rubocop:enable Metrics/MethodLength
  end
end
