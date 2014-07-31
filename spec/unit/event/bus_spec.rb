require "unit_helper"
require "event_sourcing/event/bus"

describe EventSourcing::Event::Bus do
  let(:bus) { EventSourcing::Event::Bus.new(event_store) }
  let(:event_store) { instance_double("EventSourcing::Event::Store::Memory") }

  it "is a RestartingContext" do
    expect(EventSourcing::Event::Bus < Concurrent::Actor::RestartingContext).to be_truthy
  end

  it "uses a custom Reference class" do
    expect(bus.default_reference_class).to eq(EventSourcing::Event::Bus::Reference)
  end

  context "when sent a :get_event_store message" do
    it "returns the event store" do
      expect(bus.on_message(:get_event_store)).to eq(event_store)
    end
  end

  context "when sent a :get_event_publisher message" do
    
    let(:publisher_class)   { class_double("EventSourcing::Event::Publisher").as_stubbed_const }
    let(:publisher) { double("Publisher ref") }
    
    subject { bus.on_message(:get_event_publisher) }

    before do
      allow(publisher_class).to receive(:spawn!).once.with(name: :event_publisher, supervise: true).and_return(publisher)
    end

    it "returns a supervised event publisher" do
      expect(subject).to eq(publisher)
    end

    it "memoizes the reference" do
      expect(subject).to eq(bus.on_message(:get_event_publisher))
    end
  end
end
