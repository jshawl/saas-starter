Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.application.credentials.dig(:auth0, :client_id),
    Rails.application.credentials.dig(:auth0, :client_secret),
    Rails.application.credentials.dig(:auth0, :domain),
    callback_path: '/auth/auth0/callback',
    authorize_params: {
      scope: 'openid profile'
    }
  )
end
OmniAuth.configure do |config|
  # Always use /auth/failure in any environment
  config.failure_raise_out_environments = []
end
