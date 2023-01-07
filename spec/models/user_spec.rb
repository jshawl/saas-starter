require "rails_helper"

RSpec.describe "User" do
  fixtures :users
  it "has an email address" do
    expect(users(:alice).email).to be_present
  end
end
