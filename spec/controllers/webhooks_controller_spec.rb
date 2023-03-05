# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Webhooks', type: :request do
  fixtures :users

  before do
    # todo: fixtures for Payment
    users(:alice).payments.create(
      paypal_subscription_id: 'I-BW452GLLEP1G',
      details: {
        status: 'ACTIVE'
      }
    )
  end
  it 'processes BILLING.SUBSCRIPTION.CANCELLED' do
    post '/webhooks', headers: {
      'Content-Type': 'application/json'
    }, params: File.read("spec/mocks/paypal-webhook-BILLING.SUBSCRIPTION.CANCELLED.json")
    expect(users(:alice).payments.last.details['status']).to eq('CANCELLED')
  end
end
