require "unit_helper"
require "event_sourcing/command"

describe EventSourcing::Command do
  it "expects a block" do
    expect { EventSourcing::Command.define }.to raise_error("Commands require an execution block")
  end

  it "can't be directly instantiated" do
    expect { EventSourcing::Command.new }.to raise_error(NoMethodError)
  end

  context "instance" do
    subject { EventSourcing::Command.define {} }

    it "is a EventSourcing::Command" do
      expect(subject.new).to be_a(EventSourcing::Command)
    end
  end

  context "with required parameters" do
    subject { EventSourcing::Command.define(:title) {} }

    it "can't be instantiated if those are not provided" do
      expect { subject.new }.to raise_error(ArgumentError, "missing keyword: title")
    end
  end

  context "execute" do
    let(:dependency) { double("Dependency", value: 42)}
    let(:command)    { EventSourcing::Command.define(:prop) { |dep| "returning #{dep.value} and #{prop}"} }
    subject { command.new(prop: "own_stuff") }    

    it "runs the passed block under the current command context" do
      expect(subject.execute(dependency)).to eq("returning 42 and own_stuff")
    end
  end
end
