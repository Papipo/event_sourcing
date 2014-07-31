module EventSourcing
  class Command
    private_class_method :new

    def self.define(*fields, &block)
      raise "Commands require an execution block" unless block_given?

      Class.new(self) do
        public_class_method :new
        attr_reader(*fields)

        class_eval %{
          def initialize(#{fields.map { |a| "#{a}:"}.join(',')})
            #{fields.map { |f| "@#{f} = #{f}" }.join(';') }
          end
        }

        define_method :execute do |*args|
          instance_exec(*args, &block)
        end
      end
    end
  end
end
