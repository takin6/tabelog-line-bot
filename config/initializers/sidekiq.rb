Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379', namespace: "sidekiq_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:6379", namespace: "sidekiq_#{Rails.env}" }
end

Sidekiq::Logging.logger = Logger.new(Rails.root + "log/sidekiq.log", 3, 10 * 1024 * 1024)
