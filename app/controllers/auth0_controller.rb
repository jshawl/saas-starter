# frozen_string_literal: true

# Auth0 request handlers
class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    session[:userinfo] = auth_info['extra']['raw_info']
    @user = User.create_from_omniauth!(auth_info)
    sign_in @user
    redirect_to account_path
  end

  def failure
    @error_msg = request.params['message']
  end

  def logout; end
end
