
module EventSourcing
  class Event

    private_class_method :new

    def self.define(*fields)
      Class.new(self) do
        attr_reader(*fields)
        public_class_method :new

        class_eval %{
          def initialize(#{fields.map { |f| "#{f}:" }.join(',')})
            #{fields.map { |f| "@#{f} = #{f}" }.join(';')}
          end
        }
      end
    end
  end
end