set :application, '_application_name_'
set :repo_url, "file://#{File.expand_path('.')}"

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, %w{config/database.yml config/secrets.yml}
set :whenever_variables, -> { "'environment=#{fetch(:rails_env)}&deploy_to=#{fetch(:deploy_to)}'"}
set :branch, ENV["REVISION"] || ENV["BRANCH"] || ENV["CI_BUILD_REF"] || "master"
set :scm, :gitcopy
set :format, :pretty
set :log_level, :info

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end
end
