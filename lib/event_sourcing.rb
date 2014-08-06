require "event_sourcing/version"

module EventSourcing
  def self.require_keywords(required, present)
    missing_keys = required - present
        
    if missing_keys.any?
      raise ArgumentError, "missing keyword: #{missing_keys.first}"
    end
  end
end
