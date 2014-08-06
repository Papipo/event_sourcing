require "concurrent/actor"

module EventSourcing
  module Aggregate
    class Actor
      def self.for(aggregate)
        #FIXME: this might be doing too many things

        Class.new(Concurrent::Actor::RestartingContext) do
          define_method :initialize do |event_bus, id|
            @event_stream = event_bus.get_stream(id)
            @aggregate = aggregate.new(@event_stream)
          end

          def on_message(message)
            if @aggregate.respond_to?(message.first)
              events = @aggregate.send(*message) # FIXME: what happens if events is empty or falsy?
              @event_stream = @event_stream << events
              # FIXME: spec what happens if event hasn't been stored for some reason
              @aggregate._apply(events)
            end
          end
        end
      end
    end
  end
end
