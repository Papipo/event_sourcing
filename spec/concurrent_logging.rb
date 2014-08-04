require "concurrent"
require "logger"

$logger = Logger.new(File.dirname(__FILE__) + '/../log/test.log')
$logger.level = Logger::DEBUG

Concurrent.configuration.logger = lambda do |level, progname, message = nil, &block|
  $logger.add level, message, progname, &block
end
