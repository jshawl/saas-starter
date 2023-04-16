# frozen_string_literal: true

module Admin
  # A namespace for admin pages
  class UsersController < ApplicationController
    before_action :authorize_user!
    def index
      @users = User.paginate(page: params[:page])
    end

    def show
      @user = User.find(params[:id])
    end

    private

    def authorize_user!
      raise(ActionController::RoutingError, 'Not Found') unless current_user.is_admin?
    end
  end
end
