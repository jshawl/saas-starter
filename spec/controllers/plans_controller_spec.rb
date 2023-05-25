require 'rails_helper'

RSpec.describe PlansController, type: :controller do
  it 'has an index page' do
    stub_request(:post, "https://api-m.sandbox.paypal.com/v1/oauth2/token").
         to_return(status: 200, body: "", headers: {})
    stub_request(:get, "https://api-m.sandbox.paypal.com/v1/billing/plans").
    to_return(status: 200, body: '{"plans": []}', headers: {})
    get :index
  end
end
