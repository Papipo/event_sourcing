require "unit_helper"
require "event_sourcing/aggregate/manager"

describe EventSourcing::Aggregate::Manager do
  it "is a restarting actor" do
    expect(EventSourcing::Aggregate::Manager.ancestors).to include(Concurrent::Actor::RestartingContext)
  end

  context "on message of kind Aggregate::Message" do
    let(:aggregate) { double("Aggregate") }
    let(:instance)  { double("Aggregate instance") }
    let(:cache_class) { class_double("EventSourcing::Aggregate::Manager::Cache").as_stubbed_const }
    let(:cache_instance) { instance_double("EventSourcing::Aggregate::Manager::Cache") }
    let(:manager) { EventSourcing::Aggregate::Manager.new(event_bus) }
    let(:event_bus) { double("EventSourcing::Event::Bus::Reference") }
    let(:wrapped_message) { EventSourcing::Aggregate::Message.new(aggregate, "some-id", actual_message) }
    let(:actual_message) { :publish }

    before do
      allow(cache_class).to receive(:new).with(event_bus).once.and_return(cache_instance)
      allow(cache_instance).to receive(:instance_of).with(aggregate, "some-id").and_return(instance)
    end

    after do
      manager.on_message(wrapped_message)
    end

    it "redirects the message to the aggregate actor" do
      expect(instance).to receive(:tell).with(actual_message)
    end
  end
end
