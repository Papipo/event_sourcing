require_relative "../support/sample_app"
require "event_sourcing/event/store/memory"

class Spinach::Features::WholeStack < Spinach::FeatureSteps
  before do
    File.open(SampleApp::Logger.file_path, "w")
  end

  step 'my app is running' do
    @app = SampleApp.run!(event_store: event_store)
  end

  step 'I send a command to an aggregate' do
    @app.execute_command SampleApp::PublishPost.new(post_id: "some-id", title: "My post")
  end

  step 'an event is raised' do
    sleep 0.01 #FIXME wait with timeout instead
    expect(File.read(SampleApp::Logger.file_path)).to eq("Post with title \"My post\" has been published!\n")
  end

  after do
    @app.shutdown if @app
  end

  def event_store
    @event_store ||= EventSourcing::Event::Store::Memory.new
  end
end
