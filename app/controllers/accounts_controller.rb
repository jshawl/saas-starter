# frozen_string_literal: true

# Accounts routes
class AccountsController < ApplicationController
  before_action :authenticate_user!
  def show; end

  def subscribe; end
end
