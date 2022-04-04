require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "shellwords"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UnifonicAuthenticate
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.autoload_paths += %w[components lib].map { |dir| "#{config.root}/#{dir}" }
    config.eager_load_paths += %w[components].map { |dir| "#{config.root}/#{dir}" }

    console do
      Rails.logger.level = :debug
    end
    config.hosts.clear
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # config.active_job.queue_adapter = :sidekiq
    # config.paperclip_defaults = {
    #   :storage => :s3,
    #   :preserve_files => !!(ENV["authenticate_aws_s3_preserve_files"]),
    #   :s3_host_name => ENV["authenticate_aws_s3_host_name"],
    #   :s3_credentials => {
    #     :access_key_id => ENV["authenticate_aws_s3_access_key_id"],
    #     :secret_access_key => ENV["authenticate_aws_s3_secret_access_key"],
    #     :s3_region => ENV["authenticate_aws_s3_region"]
    #   },
    #   :bucket => ENV["authenticate_aws_s3_bucket"]
    # }
  end
end
