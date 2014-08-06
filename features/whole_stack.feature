Feature: Whole stack
  
  Scenario: Sending commands to aggregates
    Given my app is running
    When I send a command to an aggregate
    Then an event is raised

  Scenario: Aggregate recovery
    Given my app is running
    When an aggregate terminates suddenly
    Then I can still send commands to that aggregate

  Scenario: Multiple commands handled by a given aggregate
    Given my app is running
    When I send several commands to an aggregate
    Then it can handle all of them
    