threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Specifies the `environment` that Puma will run in.
# Defaults to development
rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

app_dir = File.expand_path("../..", __FILE__)
directory app_dir
shared_dir = "#{app_dir}/tmp"

if %w[production staging].member?(rails_env)
  # Logging
  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  # Set up socket location
  bind "unix://#{shared_dir}/sockets/puma.sock"

  # Set master PID and state locations
  pidfile "#{shared_dir}/pids/puma.pid"
  state_path "#{shared_dir}/pids/puma.state"

  # Change to match your CPU core count
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }

  activate_control_app
  on_worker_boot do
    require "active_record"
    ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
    require 'erb'
    ActiveRecord::Base.establish_connection( YAML.load( ERB.new( File.read( "#{app_dir}/config/database.yml" )).result)[rails_env])
  end

elsif rails_env == "development"
  # Specifies the `port` that Puma will listen on to receive requests; default is 3000.
  port   ENV.fetch("PORT") { 3000 }
  plugin :tmp_restart
end
