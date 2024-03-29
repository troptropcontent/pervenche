# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
ENV['CI'] ||= 'true'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'json_matchers/rspec'
require 'sidekiq/testing'
require Rails.root.join('spec/requests/shared_example/an_authenticated_endpoint')
require Rails.root.join('spec/requests/shared_example/an_operationnal_endpoint')
require Rails.root.join('spec/support/request_spec_extendable_helpers')
require Rails.root.join('spec/support/request_spec_includable_helpers')
require Rails.root.join('spec/support/shared_context/stubed_pay_by_phone')

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # will allow things like that
  # before do |example|
  #   puts 'before hook' unless example.metadata[:skip]
  # end

  # it 'will use before hook' do
  # end

  # it 'will not use before hook', :skip do
  # end
  # config.treat_symbols_as_metadata_keys_with_true_values = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join('spec/fixtures')

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :request

  # custom ReqestHelper 'home made' rswagger syntax
  config.extend RequestSpecExtendableHelpers, type: :request
  config.include RequestSpecIncludableHelpers, type: :request

  # sidekiq
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # chargee_bee stubs
  config.before(:each) do |_example|
    chargebee_customer_double = double(ChargeBee::Customer)
    allow(chargebee_customer_double).to receive(:id).and_return('a_charge_bee_customer_id')
    allow(chargebee_customer_double).to receive(:customer).and_return(chargebee_customer_double)
    allow(ChargeBee::Customer).to receive(:create).and_return(chargebee_customer_double)
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true
end
