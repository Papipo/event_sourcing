module EventSourcing
  class CoreClass

    private_class_method :new

    def self.define(fields, &block)
      Class.new(self) do
        public_class_method :new
        setup_fields(fields)
        class_eval &block
      end
    end

    private

    def self.setup_fields(fields)
      unless fields.empty?
        define_method :initialize do |properties = {}|
          require_keys(fields, properties.keys)
          set_properties(fields, properties)
        end

        attr_reader(*fields)
      end
    end

    def require_keys(present, required)
      missing_keys = present - required
    
      if missing_keys.any?
        raise ArgumentError, "missing keyword: #{missing_keys.first}"
      end
    end

    def set_properties(fields, properties)
      fields.each do |field|
        instance_variable_set("@#{field}", properties[field])
      end
    end
  end
end