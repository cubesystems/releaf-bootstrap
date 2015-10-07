require 'simplecov'
require 'simplecov-rcov'

if ENV["COVERAGE"]
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::RcovFormatter
  ]
  SimpleCov.start 'rails' do
    add_filter 'vendor'
    add_filter 'config/'
    add_filter 'lib/tasks/'
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'shoulda/matchers'
require 'capybara/poltergeist'
require 'releaf/rspec'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Add additional requires below this line. Rails is not loaded until this point!

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
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!


Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    js_errors: false,
    inspector: true,
    window_size: [1500, 3000]
  })
end

include Warden::Test::Helpers

RSpec.configure do |config|
  config.include NodeHelpers
  config.include Releaf::TestHelpers

  if ENV['CI']
    config.tty = true
    config.add_formatter(:progress)
    config.add_formatter("ParallelTests::RSpec::RuntimeLogger", "tmp/parallel_runtime_rspec.log")
  end

  # DEVISE
  config.include Devise::TestHelpers, type: :controller

  # FactoryGirl
  config.include FactoryGirl::Syntax::Methods

  Capybara.javascript_driver = :poltergeist

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

    # DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :truncation
    DatabaseCleaner[:active_record].clean_with(:truncation)
    I18n.locale = Releaf.available_locales.first
    I18n.default_locale = Releaf.available_locales.first

    # disable empty translation creation
    Releaf::I18nDatabase.create_missing_translations = false
  end

  config.before(:each) do
    date_and_time_translations = {
      time: {
        formats: {
          default: "%Y.%m.%d %H:%M"
        }
      },
      date: {
        formats: {
          default: "%d.%m.%Y"
        }
      }
    }

    # store  date and time translations
    [:lv, :en].each do |locale|
      I18n.backend.store_translations(locale, date_and_time_translations)
    end

    # never reload (clear) releaf translations cache
    allow_any_instance_of(Releaf::I18nDatabase::Backend).to receive(:reload_cache?) { false }

    SimpleCov.command_name "RSpec:#{Process.pid}#{ENV['TEST_ENV_NUMBER']}"

    if Capybara.current_driver == :rack_test
      DatabaseCleaner[:active_record].strategy = :transaction
    else
      DatabaseCleaner[:active_record].strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after(:each) do
    # reset only for feature tests with poltergeist
    if Capybara.current_driver != :rack_test
      current_step = 1
      while (page.evaluate_script('jQuery.active > 0') && current_step < 10)
        current_step += 1
        sleep 0.5
      end
      Capybara.reset_sessions!
    end

    DatabaseCleaner.clean
    Warden.test_reset!
  end
end
