# TODO Remove
require "values"
require "event_sourcing/aggregate/manager"

module EventSourcing
  module Aggregate
    class Manager
      InstanceOf = Value.new(:aggregate, :id)
    end
  end
end