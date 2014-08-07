require "event_sourcing/event"

module EventSourcing
  class Event
    module Store
      class ConcurrencyError < RuntimeError
      end
    end
  end
end
