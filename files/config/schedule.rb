job_type :unicorn_start, "cd :path && RAILS_ENV=:environment bundle exec unicorn_rails -c :path/config/unicorn/:environment.rb -D"
job_type :logrotate,     "cd :path && RAILS_ENV=:environment logrotate -f -s :path/log/logrotate.state :path/config/logrotate.conf"

every :reboot do
  unicorn_start ''
end

every :day, :at => '2:30am' do
  logrotate ''
end
