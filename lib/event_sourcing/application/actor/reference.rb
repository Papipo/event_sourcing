require "concurrent/actor"
require "event_sourcing/application/actor"

module EventSourcing
  module Application
    class Actor
      class Reference < Concurrent::Actor::Reference
        def execute_command(command)
          command_bus.tell(command)
        end

        def terminate!
          ask(:terminate!).wait
        end

        private
        def command_bus
          @command_bus ||= ask!(:get_command_bus)
        end
      end
    end
  end
end
