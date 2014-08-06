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
    send_command SampleApp::PublishPost.new(post_id: "some-id", title: "My post")
  end

  step 'an event is raised' do
    expect(File.read(SampleApp::Logger.file_path)).to eq("Post with title \"My post\" has been published!\n")
  end

  step 'an aggregate terminates suddenly' do
    @app.execute_command SampleApp::BrokenCommand.new(post_id: "some-id")
  end

  step 'I can still send commands to that aggregate' do
    publish_post
    expect(event_store.events).not_to be_empty
  end

  step 'I send several commands to an aggregate' do
    publish_post
    rename_post("New title")
  end

  step 'it can handle all of them' do
    expect(event_store.events.size).to eq(2)
  end


  after do
    @app.shutdown if @app
    sleep 0.01 # FIXME shouldn't need this
  end

  private
  def event_store
    @event_store ||= EventSourcing::Event::Store::Memory.new
  end

  def rename_post(title)
    send_command SampleApp::RenamePost.new(post_id: "some-id", title: title)
  end

  def publish_post
    send_command SampleApp::PublishPost.new(post_id: "some-id", title: "My post")
  end

  def send_command(command)
    @app.execute_command command
    sleep 0.01 #FIXME: Should support simultaneous commands
  end
end
