Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry_dsn)
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
end
