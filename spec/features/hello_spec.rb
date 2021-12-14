
require 'rails_helper'

RSpec.describe 'index page', type: :feature do
  describe 'root path' do
    it 'shows something' do
      visit root_path
      expect(page).to have_content('My Awesome Product')
    end
  end
end