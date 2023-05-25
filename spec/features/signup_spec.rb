# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'index page', type: :feature do
  describe 'root path' do
    it 'shows something' do
      visit root_path
      expect(page).to have_content(Rails.application.config.title)
    end

    it 'signs up with marketing opt-in' do
      visit new_user_registration_path
      fill_in 'user_email', with: 'example@example.com'
      fill_in 'user_password', with: 'abc123'
      fill_in 'user_password_confirmation', with: 'abc123'
      check 'user_marketing_opted_in'
      stub_request(:put, 'https://api.sendgrid.com/v3/marketing/contacts')
        .to_return(status: 202, body: '')
      expect do
        click_on 'Sign up'
      end.to change { User.count }.by(1)
      expect(User.last.marketing_opted_in?).to eq(true)
    end
  end
end
