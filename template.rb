BASE_URL = ENV["BASE_URL"] || "https://raw.githubusercontent.com/cubesystems/releaf-bootstrap/master/"
public_site = ENV['WITH_FRONTEND'].present? || yes?('Install basic frontend support? (yes/no)')

gem 'unicorn'
gem 'releaf'
gem 'airbrake'
gem 'http_accept_language'

gem_group :development, :deployment do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
  gem 'capistrano-scm-gitcopy'
  gem 'whenever', require: false
end

gem_group :development, :test do
  gem 'poltergeist'
  gem 'minitest'
  gem 'rspec-rails'
  gem "capybara"
  gem "simplecov", require: false
  gem 'simplecov-rcov'
  gem "database_cleaner"
  gem 'shoulda-matchers'
  gem 'pry'
  gem 'pry-nav'
  gem "factory_girl_rails", require: false
end

run "bundle install"
run "rails generate releaf:install"

files = [
  ".gitignore",
  ".gitlab-ci.yml",
  ".rspec",
  "Capfile",
  "config/deploy.rb",
  "config/deploy/production.rb",
  "config/deploy/staging.rb",
  "config/unicorn/production.rb",
  "config/unicorn/staging.rb",
  "config/schedule.rb",
  "config/logrotate.conf",
  "config/initializers/assets.rb",
  "config/initializers/airbrake.rb",
  "spec/factories/common.rb",
  "spec/factories/role.rb",
  "spec/factories/users.rb",
  "spec/rails_helper.rb",
  "spec/spec_helper.rb",
  "spec/support/node_helpers.rb",
]

if public_site
  generate "model", "text_page text_html:text"
  generate "model", "home_page intro_text_html:text"

  files += [
    "app/models/node.rb",
    "app/models/text_page.rb",
    "app/models/home_page.rb",
    "app/controllers/concerns/node_controller.rb",
    "app/controllers/application_controller.rb",
    "app/controllers/text_pages_controller.rb",
    "app/controllers/home_pages_controller.rb",
    "app/views/home_pages/show.haml",
    "app/views/text_pages/show.haml",
    "app/views/layouts/application.haml",
    "spec/controllers/application_controller_spec.rb",
    "spec/controllers/home_pages_controller_spec.rb",
    "spec/controllers/text_pages_controller_spec.rb",
    "spec/factories/home_pages.rb",
    "spec/factories/nodes.rb",
    "spec/factories/text_pages.rb",
    "spec/features/home_pages_spec.rb",
    "spec/features/layout_spec.rb",
    "spec/features/menu_spec.rb",
    "spec/features/text_pages_spec.rb",
    "spec/models/home_page_spec.rb",
    "spec/models/text_page_spec.rb",
    "spec/support/shared/controllers/node_controller_concern.rb",
    "spec/support/shared/models/node_model.rb",
  ]
else
  remove_file "app/models/node.rb", verbose: false

  node_migration_file = `ls db/migrate | grep releaf_nodes`.strip
  remove_file "db/migrate/#{node_migration_file}", verbose: false

  files += [
    "config/initializers/releaf.rb",
  ]
end

files.each do|file|
  remove_file(file, verbose: false)
  get "#{BASE_URL}files/#{file}", file
  gsub_file file, /_application_name_/, @app_name, verbose: false
end

gsub_file "config/initializers/releaf.rb", 'config.available_locales = ["en"]', 'config.available_locales = ["lv", "en"]', verbose: false
remove_file "app/views/layouts/application.html.erb", verbose: false
run "rm -Rf test"

run "cp config/secrets.yml config/example.secrets.yml"
run "cp config/database.yml config/example.database.yml"
run "cp config/environments/production.rb config/environments/staging.rb"

rake "db:create"
rake "db:migrate"
rake "db:seed"

rake "db:create", env: "test"
rake "db:migrate", env: "test"

run "spring binstub --all"

route 'mount_releaf_at "/admin"'
if public_site
  route '
    node_routes_for(HomePage) do
      get "show", as: "home"
    end

    node_routes_for(TextPage) do
      get "show"
    end
    root to: "application#redirect_to_locale_root"
  '
end

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
run "spring stop" # stop auto-started spring as it may fuck-up other site generation processes
