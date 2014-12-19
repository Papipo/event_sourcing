require "concurrent/actor"
require "event_sourcing/aggregate/manager"
require "event_sourcing/command/bus"
require "event_sourcing/event/bus"

module EventSourcing
  module Application
    class Actor < Concurrent::Actor::RestartingContext
      require "event_sourcing/application/actor/reference"

      def default_reference_class
        Reference
      end

      def initialize(event_store)
        @event_store = event_store
        @event_bus   = EventSourcing::Event::Bus.spawn!(name: :event_bus, supervise: true, args: [@event_store])
        @aggregate_manager = EventSourcing::Aggregate::Manager.spawn!(name: :aggregate_manager, supervise: true, args: [@event_bus])
        @command_bus = EventSourcing::Command::Bus.spawn!(name: :command_bus, supervise: true, args: [@aggregate_manager])
      end

      def on_message(message)
        case message
        when :get_command_bus
          @command_bus
        when :get_event_bus
          @event_bus
        when :get_aggregate_manager
          @aggregate_manager
        end
      end
    end
  end
end
