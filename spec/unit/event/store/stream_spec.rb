require "unit_helper"
require "event_sourcing/event/store/stream"

describe EventSourcing::Event::Store::Stream do

  subject       { stream }
  let(:stream)  { EventSourcing::Event::Store::Stream.new("some-id", events, version, store) }
  let(:events)  { [double("Event")] }
  let(:version) { 1 }
  let(:store)   { instance_double("EventSourcing::Event::Store::Memory") }

  it "is a enumerable list of events" do
    expect(subject.first).to eq(events.first)
  end

  it "has a version" do
    expect(subject.version).to eq(version)
  end

  context "append" do
    let(:new_stream) { instance_double("EventSourcing::Event::Store::Stream") }

    before do
      allow(store).to receive(:append).with("some-id", version, events).and_return(new_stream)
    end

    subject { stream.append(events) }

    it "pushes events into the event store and returns a new stream" do
      expect(subject).to eq(new_stream)
    end
  end
end
