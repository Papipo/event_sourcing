require "spec_helper"
require "event_sourcing/event/store/memory"

describe EventSourcing::Event::Store::Memory do
  it_behaves_like "a store implementation"
end