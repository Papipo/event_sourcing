require "concurrent/actor"

module EventSourcing
  module Aggregate
    class Actor
      def self.for(aggregate)
        Class.new(Concurrent::Actor::RestartingContext) do
          define_method :initialize do |event_bus, event_stream|
            @aggregate = aggregate.new(event_stream)
            @event_bus = event_bus
            @event_stream = event_stream
          end

          #FIXME: this is doing too many things

          def on_message(message) # Format is [:method, arg1, arg2]
            if @aggregate.respond_to?(message.first)
              events = @aggregate.send(*message) # FIXME: what happens if events is empty or falsy?
              @event_stream.append(events) # FIXME: Event Stream is now stale
              @event_bus.publish(events) 
              # FIXME: spec what happens if event hasn't been stored for some reason
              @aggregate._apply(events)
            end
          end
        end
      end
    end
  end
end
