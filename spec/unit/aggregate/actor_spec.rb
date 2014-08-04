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
    let(:event_stream) { instance_double("EventSourcing::Event::Bus::Stream") }
    let(:actor) { EventSourcing::Aggregate::Actor.for(aggregate_class).new(event_stream) }

    before do
      allow(aggregate_instance).to receive(:_apply).with(:published)
      allow(event_stream).to receive(:<<)
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
