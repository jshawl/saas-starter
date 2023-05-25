require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  fixtures :users
  it 'has a show page' do
    sign_in users(:alice)
    get :show
  end
end
