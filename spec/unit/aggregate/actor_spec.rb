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
    let(:aggregate_class) { double("Aggregate class", new: aggregate_instance, instance_methods: [:publish])}
    let(:aggregate_instance) { double("Aggregate instance", publish: :published)}
    let(:event_stream) { instance_double("EventSourcing::Event::Stream") }
    let(:event_bus)    { instance_double("EventSourcing::Event::Bus::Reference") }
    let(:actor) { EventSourcing::Aggregate::Actor.for(aggregate_class).new(event_bus, event_stream) }

    before do
      allow(aggregate_instance).to receive(:_apply).with(:published)
      allow(event_bus).to receive(:publish)
      allow(event_stream).to receive(:append)
    end
    
    context "when receiving supported messages" do
      after do
        subject.on_message([:publish, :some_arg])
      end

      it "stores the events using the stream" do
        expect(event_stream).to receive(:append).with(:published)
      end

      it "delegates on aggregate and publishes events" do
        expect(event_bus).to receive(:publish).with(:published)
      end

      it "gets events applied" do
        expect(aggregate_instance).to receive(:_apply).with(:published)
      end   
    end

    context "when receiving unsupported messages" do
      after do
        subject.on_message([:fake])
      end

      it "does nothing" do
        expect(event_bus).not_to receive(:publish)
      end
    end
  end
end
