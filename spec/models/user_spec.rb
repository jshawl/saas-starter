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
end
