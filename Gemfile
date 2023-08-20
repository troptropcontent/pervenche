source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

#beautiful prints
gem 'amazing_print'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4', '>= 7.0.4.1'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

#validates phone
gem 'phonelib'

# Sentry to catch all errrors
gem 'sentry-ruby'
gem 'sentry-rails'
gem 'sentry-sidekiq'

#pagination
gem 'kaminari'

#views
gem "scenic"

#Notification
gem 'noticed'

#view component
gem "view_component"

#Logging
gem 'lograge'
gem 'lograge-sql'
gem 'newrelic_rpm'

# Explore your data with SQL. Easily create charts and dashboards, and share them with your team.
gem "blazer"
# store static data in hashes
gem 'active_hash', '~> 2.3.0'

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
# gem 'tailwindcss-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# simple form
gem 'simple_form'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# svgs
gem 'inline_svg'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Money
gem 'money-rails', '~>1.12'

#Chargebee
gem 'chargebee', '~>2'

# Htt requests
gem 'faraday', '>= 2.7.2'

#Typing with sorbet
gem 'sorbet-runtime'

#emails
gem 'sendgrid-ruby'

#Authorisation
gem 'cancancan'

#Authentification
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

#Background jobs
gem 'sidekiq', '~> 7.0'

#Actors
gem 'service_actor-rails', '~> 1.0'

#Uistiti toolkit
gem 'uistiti', git: 'https://github.com/troptropcontent/uistiti.git', branch: 'development'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'rspec-sorbet'
end

group :development do
  #Typing with sorbet
  gem 'sorbet'
  gem 'tapioca'

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # erb-lint
  gem 'erb_lint', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-sorbet', require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'factory_bot_rails'
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'webdrivers'
  gem "vcr"
  gem "webmock"
  gem "json_matchers"
  gem 'database_cleaner-active_record'
end

