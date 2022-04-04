source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'rails', '~> 6.0.4.1'
gem 'pg'
gem 'rack-protection'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'kaminari'
gem "jwt"
gem 'rake', '~> 13.0.4'

# fixed snyk Vulnerabilities
gem "json", ">= 2.3.0"
gem 'puma', '~> 5.2'

gem 'curb', '~> 0.9.10'
gem 'exception_notification'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'redis-rails'
gem 'redis'
gem 'hiredis'
gem 'redis-namespace'
gem 'rack-cors'
gem 'rack-attack'
group :development, :test do
  gem 'rspec-rails'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'mocha'
  gem 'webmock'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'simplecov', "<= 0.17.1", require: false, group: :test
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end
