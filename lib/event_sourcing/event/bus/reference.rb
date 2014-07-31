require "concurrent/actor"
require "event_sourcing/event/bus"

module EventSourcing
  class Event
    class Bus
      class Reference < Concurrent::Actor::Reference

        def publish(events)
          publisher.publish(events)
        end

        def get_stream(id)
          store.get_stream(id)
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
