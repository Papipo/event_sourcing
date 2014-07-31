require "unit_helper"
require "event_sourcing/event/subscriber"

describe EventSourcing::Event::Subscriber do
  let(:subscriber) do
    Class.new(EventSourcing::Event::Subscriber) do
      subscribe_to "SomeEvent" do |event|
        "received #{event}!"
      end
    end
  end

  let(:publisher) { class_double("EventSourcing::Event::Publisher").as_stubbed_const }
  let(:event)     { event_double("SomeEvent") }

  before do
    allow(publisher).to receive(:subscribe)
  end

  it "adds the subscriber to the list of subscribers" do
    expect(publisher).to have_received(:subscribe).with(subscriber, "SomeEvent")
  end

  it "adds an event handler" do
    expect(subscriber.new.on_message(event)).to eq("received SomeEvent!")
  end
end
