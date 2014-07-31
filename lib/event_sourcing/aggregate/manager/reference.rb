require "concurrent/actor"
require "event_sourcing/aggregate/wrapper"

module EventSourcing
  module Aggregate
    class Manager
      class Reference < Concurrent::Actor::Reference
        def instance_of(aggregate, id)
          EventSourcing::Aggregate::Wrapper.new(self, aggregate, id)
        end
      end
    end
  end
end
