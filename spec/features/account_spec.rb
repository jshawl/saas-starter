
require 'rails_helper'

RSpec.describe 'account', type: :feature do
  fixtures :users
  describe 'show' do
    it 'shows payment details' do
      sign_in users(:alice)
      visit account_path
      expect(page).to have_content('Subscribe to Metered Billing')
    end

    it 'shows a link to the billing portal' do
      sign_in users(:bob)
      visit account_path
      expect(page).to have_content('Edit Subscription')
    end

  end
end
