require "rspec"
require "rspec/expectations"
require "./spec/concurrent_logging"
require "concurrent/actor"

Concurrent::Actor.i_know_it_is_experimental!