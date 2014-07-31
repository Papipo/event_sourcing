require "concurrent/actor"

module EventSourcing
  module Aggregate
    class Manager < Concurrent::Actor::RestartingContext

      require "event_sourcing/aggregate/manager/reference"
      require "event_sourcing/aggregate/manager/cache"
      require "event_sourcing/aggregate/message"

      def initialize(event_bus)
        @event_bus = event_bus
      end

      def on_message(message)
        case message
        when Aggregate::Message
          cache.instance_of(message.aggregate, message.id).tell(message.message)
          #TODO Handle aggregate timeout and failure (remove from cache)
        end
      end

      def default_reference_class
        Reference
      end

      private
      def cache
        @cache ||= Cache.new(@event_bus)
      end
    end
  end
end
