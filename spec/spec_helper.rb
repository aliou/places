if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

RSpec.configure do |config|

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    config.profile_examples = 3
  end

  config.order = :random
  Kernel.srand config.seed

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end
end
