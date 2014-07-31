require "unit_helper"
require "event_sourcing/aggregate/manager/cache"

describe EventSourcing::Aggregate::Manager::Cache do
  subject { EventSourcing::Aggregate::Manager::Cache.new(event_bus) }

  let(:aggregate) { Class.new }
  let(:actor)     { double("Actor")}
  let(:instance)  { double("Aggregate instance") }
  let(:event_bus) { instance_double("EventSourcing::Event::Bus::Reference") }
  let(:event_stream) { double("Event stream") }

  before do
    allow(event_bus).to receive(:get_stream).with("some-id").and_return(event_stream)
    aggregate.const_set("Actor", actor)
    allow(actor).to receive(:spawn!).once.with(name: "some-id", args: [event_bus, event_stream], supervise: true).and_return(instance)
  end

  it "returns instances" do
    expect(subject.instance_of(aggregate, "some-id")).to eq(instance)
  end
  
  it "memoizes instances" do
    expect(subject.instance_of(aggregate, "some-id")).to eq(subject.instance_of(aggregate, "some-id"))
  end
end
