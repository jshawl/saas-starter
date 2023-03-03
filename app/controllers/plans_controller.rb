# frozen_string_literal: true

# Routes for PayPal Plans
class PlansController < ApplicationController
  include Pricing
  def index
    @plans = build_plans_list
  end
end
