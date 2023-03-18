# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth0Controller, type: :controller do
  it 'makes a one time purchase' do
    @request.env['omniauth.auth'] = {
      'uid' => 'abcdefgh',
      'info' => {
        'name' => 'Jesse'
      },
      'credentials' => {
        'refresh_token' => 'abcdefg'
      },
      'extra' => {
        'raw_info' => 'skrrrrt'
      }
    }
    expect do
      get :callback
    end.to change { User.count }.by(1)
  end
end
