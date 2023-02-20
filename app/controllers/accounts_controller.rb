# frozen_string_literal: true

# Accounts routes
class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @payments = current_user.payments
  end
end
