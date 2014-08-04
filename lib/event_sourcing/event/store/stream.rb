module EventSourcing
  class Event
    module Store
      class Stream
        attr_reader :version
        include Enumerable
        
        def initialize(id, events, version, store)
          @id       = id
          @events  = events
          @version = version
          @store   = store
        end

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
