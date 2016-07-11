set :application, '_application_name_'
set :repo_url, '_repo_url_'

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, %w{config/database.yml config/secrets.yml}
set :whenever_variables, -> { "'environment=#{fetch(:rails_env)}&deploy_to=#{fetch(:deploy_to)}'"}
set :branch, ENV["REVISION"] || ENV["BRANCH"] || "master"

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end
end
