# frozen_string_literal: true

# routes that don't require authentication
class PublicController < ApplicationController
  include Pricing
  def index
  end
  def pricing
    @plans = build_plans_list
  end
end
