require "event_sourcing/aggregate/message"
require "values"

module EventSourcing
  module Aggregate
    class Wrapper < Value.new(:manager, :aggregate, :id)

      def method_missing(name, *args)
        manager.tell(wrap(name, args))
      end

      protected
      def wrap(method, args)
        Message.new(aggregate, id, [method] + args)
      end
    end
  end
end
