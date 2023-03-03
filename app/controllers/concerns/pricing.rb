# frozen_string_literal: true

# A cache-based interface to Plans and Pricing APIs
module Pricing
  extend ActiveSupport::Concern

  def build_plans_list
    Rails.cache.fetch('plans', expires_in: 1.hour) do
      list = PayPal::Plan.list
      list.plans.map do |plan|
        PayPal::Plan.find(plan['id']).to_h
      end
    end
  end
end
