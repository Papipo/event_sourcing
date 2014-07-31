require "unit_helper"
require "event_sourcing/aggregate"

describe EventSourcing::Aggregate do
  context "once included" do

    let(:actor_class)     { class_double("EventSourcing::Aggregate::Actor") }
    let(:aggregate_class) { Class.new }
    let(:aggregate_actor) { double("Aggregate actor") }

    before do
      stub_const("EventSourcing::Aggregate::Actor", actor_class)
      allow(actor_class).to receive(:for).with(aggregate_class).and_return(aggregate_actor)
    end
    
    subject do
      aggregate_class.class_eval do
        include EventSourcing::Aggregate
      end
    end

    it "defines an actor" do
      expect(subject::Actor).to eq(aggregate_actor)
    end
  end

  context "when it has defined handlers" do


    let(:event) { instance_double("EventSourcing::Event", to_s: "SomethingHappened") }

    let(:aggregate_class) do
      Class.new do
        include EventSourcing::Aggregate

        def do_something
          :did_something unless @something_happened
        end

        handle "SomethingHappened" do |e|
          @something_happened = true
        end
      end
    end

    let(:clean_aggregate) { aggregate_class.new() }
    let(:aggregate_with_events) { aggregate_class.new([event]) }

    it "can be initialized without an event stream" do
      expect(clean_aggregate.do_something).to eq(:did_something)
    end

    it "can be initialized with an event stream" do
      expect(aggregate_with_events.do_something).to be_nil
    end

    it "can have events applied to it" do
      clean_aggregate._apply(event)
      expect(clean_aggregate.do_something).to be_nil
    end


    context "with unsupported events" do
      let(:unsupported_event) { instance_double("EventSourcing::Event", to_s: "WrongEvent") }

      it "fails when initialized with unsupported events" do
        expect { aggregate_class.new([unsupported_event])}.to raise_error(RuntimeError, "unsupported event WrongEvent")
      end

      it "fails when unsupported events are applied" do
        expect { aggregate_class.new._apply(unsupported_event) }.to raise_error(RuntimeError, "unsupported event WrongEvent")
      end
    end
  end
end
