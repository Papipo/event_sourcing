require "unit_helper"
require "event_sourcing/event/bus/stream"

describe EventSourcing::Event::Bus::Stream do
  let(:bus_stream)   { EventSourcing::Event::Bus::Stream.new(store_stream, event_bus) }
  let(:store_stream) { instance_double("EventSourcing::Event::Store::Stream") }
  let(:event_bus)    { instance_double("EventSourcing::Event::Bus::Reference") }

  it "is an enumerable" do
    expect(bus_stream).to be_a(Enumerable)
  end

  context "<<" do
    subject { bus_stream << event }
    let(:event) { instance_double("EventSourcing::Event") }
    let(:new_store_stream) { instance_double("EventSourcing::Event::Store::Stream") }

    before do
      allow(store_stream).to receive(:append).with(event).and_return(new_store_stream)
      allow(event_bus).to receive(:publish)
    end
    
    it "appends the event(s) to the store stream and returns a new stream" do
      expect(subject).to eq(EventSourcing::Event::Bus::Stream.new(new_store_stream, event_bus))
    end

    it "publishes events to the event bus" do
      expect(event_bus).to receive(:publish).with(event)
      subject
    end
  end

  context "each" do
    before do
      @received_block = nil
      allow(store_stream).to receive(:each) { |&b| @received_block = b }
      bus_stream.each(&block)
    end

    let(:block) { lambda {} }

    it "delegates to the store stream" do
      expect(@received_block).to be(block)
    end
  end
end
