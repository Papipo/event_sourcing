require "rspec"

RSpec.configure do |config|
  config.before(:all) do
    require_relative "concurrent_logging" if RSpec.configuration.full_backtrace?
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = false
    mocks.verify_partial_doubles = false
  end
end
