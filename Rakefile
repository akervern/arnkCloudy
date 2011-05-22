require 'rake'
require 'rspec/core/rake_task'

task :default => [:test]

APP_FILE = "arnk_cloudy_app.rb"

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = FileList['test/**/*.rb']
end

task :shotgun do
  exec "shotgun #{APP_FILE}" 
end

task :sinatra do
  exec "ruby #{APP_FILE}"
end

# Thin tasks
task :clean_thin do
  Dir.glob("log/*.log").each do |file|
    File.delete(file)
  end
end

task :start => :clean_thin do
  exec "thin -s 2 -C config.yml -R config.ru start"
end

task :stop do
  exec "thin -s 2 -C config.yml -R config.ru stop"
end

task :restart do
  exec "rake stop && rake start"
end


task :autotest do
  exec "autotest"
end
