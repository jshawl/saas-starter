# frozen_string_literal: true

# routes that don't require authentication
class PublicController < ApplicationController
  def pricing
    @plans =
      Rails.cache.fetch('plans', expires_in: 1.hour) do
        list = PayPal::Plan.list
        list.plans.map do |plan|
          PayPal::Plan.find(plan['id']).to_h
        end
      end
  end
end
