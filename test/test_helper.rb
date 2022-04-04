ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  self.use_instantiated_fixtures = true

  def open_file(name)
    fixture_file_upload(file_path(name))
  end

  def read_file(name)
    File.read(file_path(name))
  end

  def file_path(name)
    "#{Rails.root}/test/fixtures/files/#{name}"
  end

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest

  def app
    Rails.application
  end

end
