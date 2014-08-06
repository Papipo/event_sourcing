require "values"

module EventSourcing
  class Event
    module Store
      class Stream < Value.new(:id, :events, :version, :store)
        include Enumerable

        def each(&block)
          @events.each(&block)
        end

        def append(events)
          @store.append(@id, @version, events)
        end
      end
    end
  end
end
