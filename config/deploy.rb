require File.expand_path("./environment", __dir__)
# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "treasure_hunter"
set :repo_url, "git@bitbucket.org:unifonic/treasure_hunter.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
#set :deploy_to, "/var/apps/treasure_hunter"

# append :rvm_map_bins, 'gem', 'ruby', 'bundle'
# set :rvm_path, '/usr/share/rvm/bin/rvm'

# run "mkdir .rvm"
# run "mkdir .rvm/bin"
# run "ln -s /usr/share/rvm/bin/rvm .rvm/bin/rvm"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.

set :sidekiq_service_name, "sidekiq_treasure_hunter"
# set :ssh_options, verify_host_key: :secure

set :puma_threads,    [4, 16]
set :puma_workers,    0


# Don't change these unless you know what you're doing
set :user,            'ubuntu'
set :use_sudo,        false
set :deploy_via,      :remote_cache
# set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :deploy_to,       "/var/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"

set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord


# set :init_system_type, :system
set :init_system, :systemd

set :sidekiq_roles, -> { :app }
set :sidekiq_systemd_unit_name, "sidekiq_treasure_hunter"

# sidekiq_cmd_pre = '~/.rvm/bin/rvm default do'
# set :sidekiq_cmd, -> { "#{sidekiq_cmd_pre} bundle exec sidekiq -e production)" }
# set :sidekiqctl_cmd, -> { "#{sidekiq_cmd_pre} RAILS_ENV=production bundle exec sidekiqctl" }
#
# set :sidekiq_pid, -> { "tmp/pids/sidekiq.pid" }

# File.join("staging.pem")
## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 10


## Linked Files & Directories (Default None):
set :linked_files, %w{config/master.key}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :sidekiq do
  desc 'Quiet sidekiq (stop fetching new tasks from Redis)'
  task :quiet do
    on roles fetch(:sidekiq_roles) do
      execute 'sudo', 'systemctl', 'kill', '-s', 'SIGTSTP', fetch(:sidekiq_systemd_unit_name), raise_on_non_zero_exit: true
    end
  end

  desc 'Stop sidekiq (graceful shutdown within timeout, put unfinished tasks back to Redis)'
  task :stop do
    on roles fetch(:sidekiq_roles) do
      # See: https://github.com/mperham/sidekiq/wiki/Signals#tstp
      execute 'sudo', 'systemctl', 'kill', '-s', 'SIGTERM', fetch(:sidekiq_systemd_unit_name), raise_on_non_zero_exit: true
      # execute 'systemctl', 'stop', fetch(:sidekiq_systemd_unit_name), raise_on_non_zero_exit: true
    end
  end

  desc 'Start sidekiq'
  task :start do
    on roles fetch(:sidekiq_roles) do
      execute 'sudo', 'systemctl', 'start', fetch(:sidekiq_systemd_unit_name)
    end
  end

  desc 'Restart sidekiq'
  task :restart do
    on roles fetch(:sidekiq_roles) do
      execute 'sudo', 'systemctl', 'restart', fetch(:sidekiq_systemd_unit_name)
    end
  end
end

namespace :deploy do
  # desc "Make sure local git is in sync with remote."
  # task :check_revision do
  #   on roles(:app) do
  #     # unless `git rev-parse HEAD` == `git rev-parse origin/master`
  #     #   puts "WARNING: HEAD is not the same as origin/master"
  #     #   puts "Run `git push` to sync changes."
  #     #   exit
  #     # end
  #   end
  # end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke! "puma:restart"
    end
  end


  before 'deploy:migrate', :copy_shared_files
  # after  :finishing,    :compile_assets
  #after  :finishing,    :copy_shared_files
  # after  :finishing,    :restart
end

after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:updated', 'sidekiq:stop'
after 'deploy:published', 'sidekiq:start'
after 'deploy:failed', 'sidekiq:restart'


# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
