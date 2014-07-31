require "concurrent/actor"

module EventSourcing
  class Event
    class Publisher < Concurrent::Actor::RestartingContext

      require "event_sourcing/event/publisher/reference"

      @subscribers = {}

      class << self
        attr_reader :subscribers

        def subscribe(klass, event)
          @subscribers[event.to_s] ||= []
          @subscribers[event.to_s] << klass
        end
      end

      def initialize
        @subscribed_actors = {}
        self.class.subscribers.each do |event,subscribers|
          @subscribed_actors[event] = subscribers.map { |s| actor_for(s) }
        end
      end

      def on_message(event)
        subscribers_for(event).each do |subscriber|
          subscriber.tell(event) # TODO: Add support for some kind of ACK + recovery
        end
      end

      def default_reference_class
        Reference
      end

      private
      def subscribers_for(event)
        @subscribed_actors[event.to_s] || []
      end

      def actor_for(subscriber)
        @actors ||= subscriber.spawn!(name: subscriber.to_s, supervise: true)
      end
    end
  end
end
