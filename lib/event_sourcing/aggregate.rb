require "event_sourcing/aggregate/actor"

module EventSourcing
  module Aggregate
    def self.included(base)
      base.const_set("Actor", EventSourcing::Aggregate::Actor.for(base))
      base.extend ClassMethods
    end

    def initialize(events = [])
      events.each do |e|
        _apply(e)
      end
    end

    def _apply(e)
      if respond_to?("apply_#{e}")
        send("apply_#{e}", e)
      else
        raise "unsupported event #{e}"
      end
    end

    module ClassMethods
      def handle(event_name, &block)
        define_method "apply_#{event_name}", &block
      end
    end
  end
end
