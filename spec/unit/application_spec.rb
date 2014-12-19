require "unit_helper"
require "event_sourcing/application"

describe EventSourcing::Application do
  let(:sample_app) { EventSourcing::Application.new(:sample_app) }

  it "can be inspected" do
    expect(sample_app.inspect).to eq("EventSourcing::Application(sample_app)")
  end

  context "while running" do
    subject { running_app }

    let(:running_app) { sample_app.run!(event_store: event_store) }
    let(:event_store) { instance_double("EventSourcing::Event::Store::Memory") }
    let(:actor_class) { class_double("EventSourcing::Application::Actor").as_stubbed_const(transfer_nested_constants: true) }
    let(:actor_reference) { instance_double("EventSourcing::Application::Actor::Reference") }

    before do
      allow(actor_class).to receive(:spawn!).with(name: :sample_app, args: [event_store]).and_return(actor_reference)
    end

    context "shutdown" do
      after { subject.shutdown }

      it "terminates the application actor" do
        expect(actor_reference).to receive(:terminate!)
      end
    end

    context "execute command" do
      let(:command) { double("Command") }
      after { subject.execute_command(command)}

      it "delegates on the application actor" do
        expect(actor_reference).to receive(:execute_command).with(command)
      end
    end
  end
end
