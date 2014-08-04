require "concurrent/actor"
require "event_sourcing/event/bus"
require "event_sourcing/event/bus/stream"

module EventSourcing
  class Event
    class Bus
      class Reference < Concurrent::Actor::Reference

        def publish(events)
          publisher.publish(events)
        end

        def get_stream(id)
          Bus::Stream.new(store.get_stream(id), self)
        end

        private
        def publisher
          @publisher ||= ask!(:get_event_publisher)
        end

        def store
          @store ||= ask!(:get_event_store)
        end
      end
    end
  end
end
