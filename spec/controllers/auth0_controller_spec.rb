# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth0Controller, type: :controller do
  before do
    @request.env['omniauth.auth'] = JSON.parse(File.read('spec/mocks/auth0-callback-facebook.json'))
  end
  it 'first callback creates a user' do
    expect do
      get :callback
    end.to change { User.count }.by(1)
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
    expect(Identity.last.email).to eq(@request.env['omniauth.auth']['info']['email'])
    expect(Identity.last.token).to eq(@request.env['omniauth.auth']['credentials']['token'])
    expect(Identity.last.refresh_token).to eq(@request.env['omniauth.auth']['credentials']['refresh_token'])
    expect(Identity.last.token_expires_at).to eq(@request.env['omniauth.auth']['credentials']['expires_at'])
  end
  it 'second callback finds the existing identity' do
    expect do
      get :callback
      get :callback
    end.to change { Identity.count }.by(1)
  end
  it 'handles failures' do
    get :failure
    expect(response).to redirect_to(root_path)
  end
end
