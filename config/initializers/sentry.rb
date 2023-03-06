Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry_dsn)
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 1.0
end
