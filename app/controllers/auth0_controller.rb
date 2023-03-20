# frozen_string_literal: true

# Auth0 request handlers
class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    @user = User.create_from_omniauth!(auth_info)
    identity = @user.identities.find_or_create_by!(
      uid: auth_info['uid'],
      provider: auth_info['provider']
    )
    identity.update!(identity_params(auth_info))
    sign_in @user
    redirect_to account_path
  end

  def failure
    flash[:notice] = 'Authentication failed!'
    redirect_to root_path
  end

  def logout; end

  private

  def identity_params(auth_info)
    { email: auth_info['info']['email'],
      token: auth_info['credentials']['token'],
      refresh_token: auth_info['credentials']['refresh_token'],
      token_expires_at: auth_info['credentials']['expires_at'] }
  end
end
