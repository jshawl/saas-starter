require 'rails_helper'

RSpec.describe PublicController, type: :controller do
  it 'has a pricing page' do
    stub_request(:post, "https://api-m.sandbox.paypal.com/v1/oauth2/token").
      to_return(status: 200, body: "", headers: {})
    stub_request(:get, "https://api-m.sandbox.paypal.com/v1/billing/plans").
      to_return(status: 200, body: '{"plans": [{"id": "P-5ML4271244454362WXNWU5NQ"}]}', headers: {})
    stub_request(:get, "https://api-m.sandbox.paypal.com/v1/billing/plans/P-5ML4271244454362WXNWU5NQ").
      to_return(status: 200, body: "{}", headers: {})
    get :pricing
  end
end
