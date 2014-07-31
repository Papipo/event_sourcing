require "unit_helper"
require "event_sourcing/command/bus"

describe EventSourcing::Command::Bus do
  let(:aggregate_manager) { instance_double("EventSourcing::Aggregate::Manager::Reference") }
  let(:command) { double("EventSourcing::Command") }

  subject { EventSourcing::Command::Bus.new(aggregate_manager) }

  after { subject.on_message(command) }

  it "executes commands" do
    expect(command).to receive(:execute).with(aggregate_manager)
  end
end
