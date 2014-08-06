require "values"

module EventSourcing
  class Event
    class Bus
      class Stream < Value.new(:store_stream, :event_bus)
        include Enumerable
        
        def <<(events)
          new_stream = store_stream.append(events)
          event_bus.publish(events)
          self.class.new(new_stream, event_bus)
        end

        def each(&block)
          store_stream.each(&block)
        end
      end
    end
  end
end
