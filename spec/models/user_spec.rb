
require 'rails_helper'

RSpec.describe 'User'do
  fixtures :users
  describe 'new_payment_method_session' do
    it 'initializes correctly' do
      u = users(:alice)
      session = u.new_payment_method_session('https://www.example.com/')
      expect(session.id).not_to be(nil)
    end
  end
end