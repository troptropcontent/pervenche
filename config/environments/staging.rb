require File.expand_path('production.rb', __dir__)

Rails.application.configure do
  # Here override any defaults
  config.log_level = :debug
end
