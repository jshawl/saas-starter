# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'account', type: :feature do
  fixtures :users
  describe 'show' do
    it 'can make a one-time purchase' do
      sign_in users(:alice)
      visit account_path
      expect(page).to have_css('iframe .paypal-button-label-container')
    end
end
