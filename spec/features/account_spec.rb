
require 'rails_helper'

RSpec.describe 'account', type: :feature do
  fixtures :users
  describe 'show' do
    before do
      stub_request(:get, "https://api.stripe.com/v1/prices?active=true").
         to_return(status: 200, body: File.read("spec/json/prices.json"))
    end
    it 'shows payment details' do
      sign_in users(:alice)
      visit account_path
      expect(page).to have_content('Professional')
    end

    it 'shows a link to the billing portal' do
      sign_in users(:bob)
      visit account_path
      expect(page).to have_content('Edit Subscription')
    end

    it 'starts checkout session' do
      u = users(:alice)
      sign_in u
      visit account_path
      find('button').click
      expect(page.current_url).to match('stripe.com')
    end

    it 'finishes checkout session' do
      u = users(:alice)
      sign_in u
      expect(u.stripe_customer_id).to be(nil)
      expect(u.stripe_subscription_id).to be(nil)
      visit account_path(session_id: 'cs_test_b1oFJciO46xif144Bf9As6fDdD6uUt2j2g1wmNGOBohjehTK8DjsCpChgQ')

      expect(u.stripe_customer_id).not_to be(nil)
      expect(u.stripe_subscription_id).not_to be(nil)
    end
  end
end