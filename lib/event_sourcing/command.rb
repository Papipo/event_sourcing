require "event_sourcing/core_class"

module EventSourcing
  class Command < CoreClass

    def self.define(*fields, &block)
      raise "Commands require an execution block" unless block_given?

      super(fields) do
        define_method :execute do |*args|
          instance_exec(*args, &block)
        end
      end
    end
  end
end
