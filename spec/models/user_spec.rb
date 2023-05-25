# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User' do
  fixtures :users
  it 'has an email address' do
    expect(users(:alice).email).to be_present
  end

  it 'sends a welcome email on user creation' do
    expect do
      User.create!(email: 'alice@bob.com', password: 'abc123')
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'can be a service account' do
    @user = User.create(email: "abc123@#{Rails.application.config.domain}")
    expect(@user.service_account?).to eq(true)
  end

  it 'does not send a welcome email to service accounts' do
    expect do
      User.create!(email: "abc123@#{Rails.application.config.domain}", password: 'abc123')
    end.to change { ActionMailer::Base.deliveries.count }.by(0)
  end

  it 'creates a marketing contact if opted in' do
    req = stub_request(:put, 'https://api.sendgrid.com/v3/marketing/contacts')
          .to_return(status: 202, body: '')
    User.create!(email: 'example@example.com', password: 'abc123', marketing_opted_in: true)
    expect(req).to have_been_requested.once
  end
end
