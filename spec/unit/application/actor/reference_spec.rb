require "unit_helper"
require "event_sourcing/application/actor/reference"

describe EventSourcing::Application::Actor::Reference do
  subject { EventSourcing::Application::Actor::Reference.new(instance_double("Concurrent::Actor::Core", is_a?: true)) }
  context "terminate!" do
    before do
      allow(subject).to receive(:ask).with(:terminate!).and_return(ivar)
    end
    
    after { subject.terminate! }

    let(:ivar) { instance_double("Concurrent::IVar") }

    it "tells the actor to terminate" do
      expect(ivar).to receive(:wait)
    end
  end

  context "execute_command" do
    let(:command)     { double("Command") }
    let(:command_bus) { double("Command bus") }
    
    after  { subject.execute_command(command) }
    before { allow(subject).to receive(:ask!).with(:get_command_bus).once.and_return(command_bus) }

    it "delegates on the command bus" do
      expect(command_bus).to receive(:tell).with(command)
    end
  end
end
