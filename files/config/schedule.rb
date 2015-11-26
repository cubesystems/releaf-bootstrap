job_type :unicorn_start, "cd #{@deploy_to}/current && RAILS_ENV=:environment bundle exec unicorn_rails -c #{@deploy_to}/current/config/unicorn/:environment.rb -D"
job_type :logrotate,     "cd #{@deploy_to}/current && RAILS_ENV=:environment logrotate -f -s #{@deploy_to}/current/log/logrotate.state #{@deploy_to}/current/config/logrotate.conf"
set :output, 'log/cron.log'


every :reboot do
  unicorn_start ''
end

every :day, at: '2:30am' do
  logrotate ''
end
