# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AdminController, type: :controller do
  fixtures :users

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
