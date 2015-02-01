desc "Run specs features and generate coverage report."
task :ci do
  rm_rf "coverage" if File.exists? 'coverage'
  ENV['RAILS_ENV'] ||= 'test'
  ENV['COVERAGE'] ||= 'y'
  ENV['CI'] = 'y'
  Rake::Task[:'db:create'].invoke
  Rake::Task[:'db:migrate'].invoke
  Rake::Task[:spec].invoke
  #Rake::Task[:'parallel:create'].invoke
  #Rake::Task[:'parallel:migrate'].invoke
  #Rake::Task[:'parallel:spec'].invoke
end
