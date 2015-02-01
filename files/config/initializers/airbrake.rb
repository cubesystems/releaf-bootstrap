Airbrake.configure do |config|
  config.api_key		 	= '_error_report_key_'
  config.host				= 'office.cube.lv'
  config.port				= 80
  config.secure			= config.port == 443
  config.ignore   << "Releaf::AccessDenied"
  config.ignore   << "ActiveRecord::StaleObjectError"
  config.ignore   << "ActionController::ParameterMissing"
end
