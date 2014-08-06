require "event_sourcing/event"

RSpec.shared_examples "a store implementation" do
  let(:event) { double("Some event") }
  let(:another_event) { double("Anothe event") }

  it "is empty when created" do
    expect(subject.events).to be_empty
  end

  context "append" do
    let(:new_event_stream) { EventSourcing::Event::Store::Stream.new("some-id", [event], 1, subject) }
    
    it "returns a new event stream" do
      expect(subject.append("stream-id", 0, event)).to eq(new_event_stream)
    end

    it "does nothing if no events are passed to it" do
      expect { subject.append("stream-id", 0, []) }.not_to change { subject.events.count }
    end
  end

  context "when events have been appended" do
    before do
      subject.append("stream-id", 0, event)
    end

    it "they can be retrieved later" do
      expect(subject.events).to eq([event])
    end

    it "they can be retrieved by stream" do
      expect(subject.get_stream("stream-id").to_a).to eq([event])
    end
  end

  context "when multiple events are appended" do
    let(:further_event) { double("Further event")}

    before do
      subject.append("stream-id", 0, [event, another_event])
      subject.append("stream-id", 2, [further_event])
    end

    it "they can be retrieved later" do
      expect(subject.events).to eq([event, another_event, further_event])
    end

    it "they can be retrieved by stream" do
      expect(subject.get_stream("stream-id").to_a).to eq([event, another_event, further_event])
    end
  end

  it "locks optimistically per stream" do
    expect {
      subject.append("stream-id", 0, event)
      subject.append("stream-id", 0, another_event)
    }.to raise_error(EventSourcing::Event::Store::ConcurrencyError)
  end

  context "with multiple streams" do
    before do
      subject.append("stream-id", 0, event)
      subject.append("another-stream-id", 0, [event, another_event])
    end

    it "allows retrieval of events by stream id" do
      expect(subject.get_stream("stream-id").version).to eq(1)
      expect(subject.get_stream("another-stream-id").version).to eq(2)
    end
  end
end
