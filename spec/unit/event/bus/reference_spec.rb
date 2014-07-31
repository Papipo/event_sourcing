require "unit_helper"
require "event_sourcing/event/bus/reference"

describe EventSourcing::Event::Bus::Reference do
  let(:bus_ref) { actor_reference(EventSourcing::Event::Bus::Reference) }
  let(:stream) { instance_double("EventSourcing::Event::Stream") }

  context "get_stream" do
    let(:store) { instance_double("EventSourcing::Event::Store::Memory") }

    before do
      allow(bus_ref).to receive(:ask!).once.with(:get_event_store).and_return(store)
      allow(store).to receive(:get_stream).with("some-id").and_return(stream)
    end

    it "returns a stream from the event store" do
      expect(bus_ref.get_stream("some-id")).to eq(stream)
    end

    it "memoizes the store" do
      expect(bus_ref.get_stream("some-id")).to eq(bus_ref.get_stream("some-id"))
    end
  end

  context "publish" do
    after { bus_ref.publish(event) }

    before do
      allow(bus_ref).to receive(:ask!).with(:get_event_publisher).and_return(publisher)
    end

    let(:event) { instance_double("EventSourcing::Event") }
    let(:publisher) { double("Publisher ref") }

    it "delegates on the memoized bus publisher" do
      expect(publisher).to receive(:publish).with(event)
    end

    context "multiple times" do
      after { bus_ref.publish(:event) }
      before { allow(publisher).to receive(:publish) }

      it "memoizes the publisher reference" do
        expect(bus_ref).to receive(:ask!).once.with(:get_event_publisher).and_return(publisher)
      end
    end
  end
end
