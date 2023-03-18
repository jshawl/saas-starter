class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    session[:userinfo] = auth_info['extra']['raw_info']
    uid = auth_info['uid']
    email = "#{SecureRandom.uuid}@#{Rails.application.config.domain}"
    password = SecureRandom.uuid
    @user = User.find_by_uid(uid)
    unless @user
      @user = User.create!(email: email, password: password, uid: uid)
    end
    sign_in @user
    redirect_to account_path
  end

  def failure
    @error_msg = request.params['message']
  end

  def logout
  end
end
