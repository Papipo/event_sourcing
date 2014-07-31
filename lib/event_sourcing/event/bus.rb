require "concurrent/actor"
require "event_sourcing/event/publisher"

module EventSourcing
  class Event
    class Bus < Concurrent::Actor::RestartingContext

      require "event_sourcing/event/bus/reference"
      
      def initialize(event_store)
        @store = event_store
        @publisher = Publisher.spawn!(name: :event_publisher, supervise: true)
      end

      def on_message(message)
        case message
        when :get_event_publisher
          @publisher
        when :get_event_store
          @store
        end
      end

      def default_reference_class
        Reference
      end
    end
  end
end
