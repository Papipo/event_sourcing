require "event_sourcing/core_class"

module EventSourcing
  class Event < CoreClass
    def self.define(*fields)
      super(fields) do
        def to_s
          self.class.to_s
        end
      end
    end
  end
end
