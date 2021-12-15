
require 'rails_helper'

RSpec.describe 'User' do
  fixtures :users
  describe 'User' do
    before do
      stub_request(:get, "https://api.stripe.com/v1/subscriptions/sub_1K5fLsJ362eyYdB5oV3jJJam").
         to_return(status: 200, body: File.read("spec/json/subscription.json"))
      
      stub_request(:post, "https://api.stripe.com/v1/subscription_items/si_KlBjDuyHSead6V/usage_records").
         to_return(status: 200, body: File.read("spec/json/usage.json"))
    end
    it 'increments usage' do
      u = users(:bob)
      Stripe::SubscriptionItem.should_receive(:create_usage_record)
      u.increment_usage
    end
  end
end