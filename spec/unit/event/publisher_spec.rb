require "unit_helper"
require "event_sourcing/event/publisher"

describe EventSourcing::Event::Publisher do
  context "subscribe" do
    SomeEvent    = EventSourcing::Event.define
    AnotherEvent = EventSourcing::Event.define
    let(:publisher)     { EventSourcing::Event::Publisher.new }
    let(:event)         { SomeEvent.new }
    let(:another_event) { AnotherEvent.new }
    let(:subscriber)    { double("subscriber class", to_s: "SubscriberClass") }
    let(:subscriber_actor) { double("Subscriber actor") } 

    before do
      EventSourcing::Event::Publisher.subscribe(subscriber, event)
      EventSourcing::Event::Publisher.subscribe(subscriber, another_event)
      allow(subscriber).to receive(:spawn!).once.with(name: "SubscriberClass", supervise: true).and_return(subscriber_actor)
    end

    after do
      publisher.on_message(event)
    end

    it "publishes events to subscribers" do
      expect(subscriber_actor).to receive(:tell).with(event)
    end
  end
end
