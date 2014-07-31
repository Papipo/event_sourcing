require "event_sourcing/application"
require "event_sourcing/event"
require "event_sourcing/event/subscriber"
require "event_sourcing/command"
require "event_sourcing/aggregate"

SampleApp = EventSourcing::Application.new(:sample_app)

SampleApp::PostPublished = EventSourcing::Event.define(:title)

SampleApp::PublishPost   = EventSourcing::Command.define(:post_id, :title) do |aggregate_manager|
  aggregate_manager.instance_of(SampleApp::Post, post_id).publish(title: title)
end

class SampleApp::Post
  include EventSourcing::Aggregate

  def publish(title:)
    ::SampleApp::PostPublished.new(title: title) unless @title
  end

  handle ::SampleApp::PostPublished do |e|
    @title = e.title
  end
end

class SampleApp::Logger < EventSourcing::Event::Subscriber

  @file_path = File.dirname(__FILE__) + '/logger.log'

  class << self
    attr_reader :file_path
  end
  
  subscribe_to SampleApp::PostPublished do |e|
    File.open(self.class.file_path, 'a') do |f|
      f.puts "Post with title \"#{e.title}\" has been published!"
    end
  end
end