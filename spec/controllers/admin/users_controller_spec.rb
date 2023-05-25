# frozen_string_literal: true

require 'rails_helper'

describe Admin::UsersController do
  fixtures :users

  describe '#index' do
    it '404s for non-admins' do
      sign_in users(:bob)
      expect { get :index }.to raise_error(ActionController::RoutingError, 'Not Found')
    end

    it '200s for admins' do
      sign_in users(:alice)
      get :index
      expect(@response.status).to eq(200)
    end
  end

  describe '#show' do
    it 'shows user details' do
      sign_in users(:alice)
      get :show, params: { id: users(:alice) }
      expect(@response.status).to eq(200)
    end
  end
end
