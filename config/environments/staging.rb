require File.expand_path('production.rb', __dir__)

Rails.application.configure do
  # Here override any defaults
  # custom logging
  config.lograge.enabled = false
  config.log_level = :debug
  config.log_formatter = ActiveSupport::Logger::SimpleFormatter.new
  config.colorize_logging = true
end
