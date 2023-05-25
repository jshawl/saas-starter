# frozen_string_literal: true

require 'rails_helper'

describe AccountsController do
  fixtures :users
  it 'has a show page' do
    sign_in users(:alice)
    get :show
    expect(response).to have_http_status(200)
  end
end
