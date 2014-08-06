require "event_sourcing"

module EventSourcing
  class Event

    private_class_method :new

    def self.define(*fields)
      Class.new(self) do
        attr_reader(*fields)
        public_class_method :new

        define_method :initialize do |properties = {}|
          EventSourcing.require_keywords(fields, properties.keys)

          fields.each do |field|
            instance_variable_set("@#{field}", properties[field])
          end
        end

        def to_s
          self.class.to_s
        end
      end
    end
  end
end
