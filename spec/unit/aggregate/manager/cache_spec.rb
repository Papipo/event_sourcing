require "unit_helper"
require "event_sourcing/aggregate/manager/cache"

describe EventSourcing::Aggregate::Manager::Cache do
  subject { EventSourcing::Aggregate::Manager::Cache.new(event_bus) }

  let(:aggregate) { Class.new }
  let(:actor)     { double("Actor")}
  let(:instance)  { double("Aggregate instance") }
  let(:event_bus) { instance_double("EventSourcing::Event::Bus::Reference") }

  before do
    aggregate.const_set("Actor", actor)
    allow(actor).to receive(:spawn!).once.with(name: "some-id", args: [event_bus, "some-id"], supervise: true).and_return(instance)
  end

  it "returns instances" do
    expect(subject.instance_of(aggregate, "some-id")).to eq(instance)
  end
  
  it "memoizes instances" do
    expect(subject.instance_of(aggregate, "some-id")).to eq(subject.instance_of(aggregate, "some-id"))
  end
end
