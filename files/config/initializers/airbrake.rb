Airbrake.configure do |config|
  config.project_key  = '_error_report_key_'
  config.project_id  = '_error_report_key_'
  config.host         = 'https://office.cube.lv'
  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end

Airbrake.add_filter do |notice|
  notice[:environment][:rails_environment] = ENV['RAILS_ENV']

  ignoreable_errors = [
    "Releaf::AccessDenied",
    "ActiveRecord::StaleObjectError",
    "ActionController::ParameterMissing"
  ]

  if notice[:errors].any?{|error| ignoreable_errors.include?(error[:type]) }
    notice.ignore!
  end
end

