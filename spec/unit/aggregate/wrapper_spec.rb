require "unit_helper"
require "event_sourcing/aggregate/wrapper"

describe EventSourcing::Aggregate::Wrapper do
  let(:manager) { instance_double("EventSourcing::Aggregate::Manager::Reference") }
  let(:wrapper) { EventSourcing::Aggregate::Wrapper.new(manager, aggregate, "some-id") }
  let(:aggregate) do
    Class.new do
      def publish
        :stuff
      end
    end
  end

  context "when is sent a message using tell" do
    after { wrapper.publish }

    it "routes it through the manager" do
      expect(manager).to receive(:tell).with(EventSourcing::Aggregate::Message.new(aggregate, "some-id", [:publish]))
    end
  end
end
