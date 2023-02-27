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
end
