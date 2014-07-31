require "event_sourcing/event/publisher"

module EventSourcing
  class Event
    class Subscriber < Concurrent::Actor::RestartingContext #TODO: Should be a plain Context?
      def self.subscribe_to(event, &block)
        define_method "handle_#{event}", &block
        Publisher.subscribe(self, event)
      end

      def on_message(event)
        send("handle_#{event}", event)
      end
    end
  end
end
