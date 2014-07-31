require "unit_helper"
require "event_sourcing/application/actor"

describe EventSourcing::Application::Actor do
  subject { EventSourcing::Application::Actor.new(event_store) }

  let(:event_store)     { instance_double("EventSourcing::Event::Store::Memory") }
  let(:command_bus)     { class_double("EventSourcing::Command::Bus").as_stubbed_const(transfer_nested_constants: true) }
  let(:command_bus_ref) { double("EventSourcing::Command::Bus::Reference") }
  let(:event_bus)       { class_double("EventSourcing::Event::Bus").as_stubbed_const(transfer_nested_constants: true) }
  let(:event_bus_ref)   { double("EventSourcing::Event::Bus::Reference") }
  let(:aggregate_manager)       { class_double("EventSourcing::Aggregate::Manager").as_stubbed_const(transfer_nested_constants: true) }
  let(:aggregate_manager_ref)   { instance_double("EventSourcing::Aggregate::Manager::Reference") }

  before do
    allow(command_bus).to receive(:spawn!).with(name: :command_bus, supervise: true, args: [aggregate_manager_ref]).and_return(command_bus_ref)
    allow(event_bus).to receive(:spawn!).with(name: :event_bus, supervise: true, args: [event_store]).and_return(event_bus_ref)
    allow(aggregate_manager).to receive(:spawn!).with(name: :aggregate_manager, supervise: true, args: [event_bus_ref]).and_return(aggregate_manager_ref)
  end

  it "uses Actor::Reference internally" do
    expect(EventSourcing::Application::Actor.new(event_store).default_reference_class).to eq(EventSourcing::Application::Actor::Reference)
  end

  it "supervises and returns a command bus" do
    expect(subject.on_message(:get_command_bus)).to eq(command_bus_ref)
  end

  it "supervises and returns an event bus" do
    expect(subject.on_message(:get_event_bus)).to eq(event_bus_ref)
  end

  it "supervises and returns an event bus" do
    expect(subject.on_message(:get_aggregate_manager)).to eq(aggregate_manager_ref)
  end  
end
