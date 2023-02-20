# frozen_string_literal: true

# Routes for PayPal Plans
class PlansController < ApplicationController
  def index
    @plans = Rails.cache.fetch('plans', expires_in: 1.hour) do
      list = PayPal::Plan.list
      list.plans.map do |plan|
        PayPal::Plan.find(plan['id']).to_h
      end
    end
  end
end
