# frozen_string_literal: true

# Auth0 request handlers
class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    @user = User.create_from_omniauth!(auth_info)
    @user.identities.find_or_create_by(
      uid: auth_info['uid'],
      provider: auth_info['provider'],
      email: auth_info['info']['email']
    )
    sign_in @user
    redirect_to account_path
  end

  def failure
    @error_msg = request.params['message']
  end

  def logout; end
end
