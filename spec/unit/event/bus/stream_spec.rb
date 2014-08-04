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
    after { bus_stream << event }
    let(:event) { instance_double("EventSourcing::Event") }
    before do
      allow(event_bus).to receive(:publish)
      allow(store_stream).to receive(:append)
    end
    
    it "appends the event(s) to the store stream" do
      expect(store_stream).to receive(:append).with(event)
    end

    it "publishes events to the event bus" do
      expect(event_bus).to receive(:publish).with(event)
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
