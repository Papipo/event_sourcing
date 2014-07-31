module ActorHelpers
  def actor_reference(ref_class)
    ref_class.new(instance_double("Concurrent::Actor::Core", is_a?: true, path: "Path for #{ref_class} core", context_class: ref_class))
  end

  def event_double(name)
    instance_double("EventSourcing::Event", to_s: name)
  end
end

RSpec.configuration.include ActorHelpers