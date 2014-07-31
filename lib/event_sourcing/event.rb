module EventSourcing
  class Event

    private_class_method :new

    def self.define(*fields)
      Class.new(self) do
        attr_reader(*fields)
        public_class_method :new

        define_method :initialize do |properties = {}|
          missing_keys = fields - properties.keys
          
          if missing_keys.any?
            raise ArgumentError, "missing keyword: #{missing_keys.first}"
          end

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
