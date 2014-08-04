require "event_sourcing/aggregate/manager"

module EventSourcing
  module Aggregate
    class Manager
      class Cache < Hash
        def initialize(event_bus)
          @event_bus = event_bus
        end

        def instance_of(aggregate, id)
          self[id] ||= aggregate::Actor.spawn!(name: id, supervise: true, args: [@event_bus.get_stream(id)])
        end
      end
    end
  end
end
