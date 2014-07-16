require "concurrent"
require "logger"

Concurrent.configuration.logger = lambda do |level, progname, message = nil, &block|
  Logger.new(File.dirname(__FILE__) + '/../log/test.log').add Logger::INFO, message, progname, &block
end
