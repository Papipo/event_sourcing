module EventSourcing
  module Application
    require "event_sourcing/application/actor"
    
    def self.new(name)
      Class.new do

        @name = name

        class << self

          attr_reader :name

          def run!(event_store:)
            new(Array(event_store))
          end

          def inspect
            "EventSourcing::Application(#{name})"
          end
        end
        
        def initialize(options)
          @actor = Actor.spawn!(name: self.class.name, args: options)
        end

        def shutdown
          @actor.terminate!
        end

        def execute_command(command)
          @actor.execute_command(command)
        end
      end
    end
  end
end
