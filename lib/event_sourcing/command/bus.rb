require "concurrent/actor"
require "event_sourcing/command"

module EventSourcing
  class Command
    class Bus < Concurrent::Actor::RestartingContext

      def initialize(aggregate_manager)
        @aggregate_manager = aggregate_manager
      end

      def on_message(command)
        command.execute(@aggregate_manager)
      end
    end
  end
end
