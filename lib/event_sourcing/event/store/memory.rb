require "event_sourcing/event"
require "event_sourcing/event/store"
require "event_sourcing/event/store/stream"

module EventSourcing
  class Event
    module Store
      class Memory
        def initialize
          @events_with_stream_id = []
        end

        def events
          @events_with_stream_id.map { |e| e[:event] }
        end

        def get_stream(id)
          events = events_for(id)
          EventSourcing::Event::Store::Stream.new(id, events, events.count, self)
        end

        def append(stream_id, expected_version, events)
          raise EventSourcing::Event::Store::ConcurrencyError if get_stream(stream_id).version != expected_version

          Array(events).tap do |events|
            events.each do |event|
              @events_with_stream_id.push(stream_id: stream_id, event: event)
            end
          end
          nil
        end

        protected
        def events_for(stream_id)
          @events_with_stream_id.select { |event| event[:stream_id] == stream_id }.map { |event| event[:event] }
        end
      end
    end
  end
end
