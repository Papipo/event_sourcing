require "unit_helper"
require "event_sourcing/aggregate/manager/reference"

describe EventSourcing::Aggregate::Manager::Reference do
  context "instance_of" do
    let(:aggregate) { double("Aggregate") }
    let(:wrapper)  { EventSourcing::Aggregate::Wrapper.new(subject, aggregate, "some-id") }
    subject { EventSourcing::Aggregate::Manager::Reference.new(instance_double("Concurrent::Actor::Core", is_a?: true)) }

    it "returns a wrapper" do
      expect(subject.instance_of(aggregate, "some-id")).to eq(wrapper)
    end
  end
end
