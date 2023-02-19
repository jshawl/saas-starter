# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'account', type: :feature do
  fixtures :users
  describe 'show' do
    it 'shows payment details' do
      sign_in users(:alice)
      visit account_path
      expect(page).to have_content('Subscribe to Metered Billing')
    end
  end
end
