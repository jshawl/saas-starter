# frozen_string_literal: true

module Admin
  # A namespace for admin pages
  class AdminController < ApplicationController
    before_action :authorize_user!
    def index
      @users = User.all
    end

    private

    def authorize_user!
      raise(ActionController::RoutingError, 'Not Found') unless current_user.is_admin?
    end
  end
end
