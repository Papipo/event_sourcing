module EventSourcing
  class Event
    class Publisher
      class Reference < Concurrent::Actor::Reference
        def publish(event)
          tell(event)
        end
      end
    end
  end
end