require "values"

module EventSourcing
  class Event
    class Bus
      class Stream < Value.new(:store_stream, :event_bus)
        include Enumerable
        
        def <<(events)
          store_stream.append(events)
          event_bus.publish(events)
        end

        def each(&block)
          store_stream.each(&block)
        end
      end
    end
  end
end
