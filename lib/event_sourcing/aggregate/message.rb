require "values"

module EventSourcing
  module Aggregate
    Message = Value.new(:aggregate, :id, :message)
  end
end
