
require 'rails_helper'

RSpec.describe 'User'do
  fixtures :users
  describe 'new_metered_billing_session' do
    it 'initializes correctly' do
      u = users(:alice)
      session = u.new_metered_billing_session('https://www.example.com/')
      expect(session.id).not_to be(nil)
    end
  end
end