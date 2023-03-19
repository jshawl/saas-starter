# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth0Controller, type: :controller do
  before do
    @request.env['omniauth.auth'] = {
      uid: 'abcdefgh',
      provider: 'google',
      info: {
        name: 'Jesse',
        email: 'jesse@jesse.sh'
      },
      credentials: {
        refresh_token: 'Sup3rS3cr3t'
      },
      extra: {
        raw_info: 'skrrrrt'
      }
    }.with_indifferent_access
  end
  it 'first callback creates a user' do
    expect do
      get :callback
    end.to change { User.count }.by(1)
    expect(User.last.email).to eq(@request.env['omniauth.auth'][:info][:email])
  end
  it 'second callback finds the existing user' do
    expect do
      get :callback
      get :callback
    end.to change { User.count }.by(1)
  end
  it 'first callback creates an identity' do
    expect do
      get :callback
    end.to change { Identity.count }.by(1)
    expect(Identity.last.email).to eq(@request.env['omniauth.auth'][:info][:email])
  end
  it 'second callback finds the existing identity' do
    expect do
      get :callback
      get :callback
    end.to change { Identity.count }.by(1)
  end
end
