require "unit_helper"
require "event_sourcing/aggregate/actor"

describe EventSourcing::Aggregate::Actor do
  context "for()" do
    let(:aggregate) { double("Aggregate class", new: true) }

    subject do
      EventSourcing::Aggregate::Actor.for(aggregate)
    end

    it "returns an actor" do
      expect(subject < Concurrent::Actor::RestartingContext).to be_truthy
    end
  end

  context "instance" do
    subject { actor }
    let(:actor) { EventSourcing::Aggregate::Actor.for(aggregate_class).new(event_bus, "some-id") }
    let(:event_bus)          { instance_double("EventSourcing::Event::Bus::Reference") }
    let(:event_stream)       { instance_double("EventSourcing::Event::Bus::Stream") }
    let(:new_event_stream)   { instance_double("EventSourcing::Event::Bus::Stream") }
    let(:aggregate_class)    { double("Aggregate class", new: aggregate_instance, instance_methods: [:publish])}
    let(:aggregate_instance) { double("Aggregate instance", publish: :published)}
    
    before do
      allow(aggregate_instance).to receive(:_apply).with(:published)
      allow(event_bus).to receive(:get_stream).with("some-id").and_return(event_stream)
      allow(event_stream).to receive(:<<).and_return(new_event_stream)
      allow(new_event_stream).to receive(:<<)
    end
    
    context "when receiving supported messages" do
      after do
        subject.on_message([:publish, :some_arg])
      end

      it "publishes the events using the stream" do
        expect(event_stream).to receive(:<<).with(:published)
      end

      it "gets events applied" do
        expect(aggregate_instance).to receive(:_apply).with(:published)
      end   

      context "followed by further messages" do
        after do
          subject.on_message([:publish, :some_arg])
        end

        it "does not use a stale event stream" do
          expect(event_stream).to receive(:<<).once
        end

        it "does use a new event stream" do
          expect(new_event_stream).to receive(:<<).with(:published)
        end
      end
    end

    context "when receiving unsupported messages" do
      after do
        subject.on_message([:fake])
      end

      it "does nothing" do
        expect(event_stream).not_to receive(:<<)
      end
    end
  end
end
