require "unit_helper"
require "event_sourcing/event"

describe EventSourcing::Event do

  module SampleNamespace
    SomeEvent = EventSourcing::Event.define
  end

  let(:event) { SampleNamespace::SomeEvent.new }

  it "can be inspected" do
    expect(event.to_s).to eq("SampleNamespace::SomeEvent")
  end

  it "can't be directly instantiated" do
    expect { EventSourcing::Event.new }.to raise_error(NoMethodError)
  end

  context "defined with required parameters" do
    subject { EventSourcing::Event.define(:required_param) }    

    it "raises an error when those are not provided" do
      expect { subject.new }.to raise_error(ArgumentError, "missing keyword: required_param")
    end

    it "has setters" do
      expect(subject.new(required_param: "some value").required_param).to eq("some value")
    end
  end

  context "defined" do
    it "are a kind of EventSourcing::Event" do
      expect(EventSourcing::Event.define.new).to be_a(EventSourcing::Event)
    end
  end
end
