# frozen_string_literal: true

# routes that don't require authentication
class PublicController < ApplicationController
  def pricing; end
end
