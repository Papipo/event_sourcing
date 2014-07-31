Feature: Whole stack
  
  Scenario: Sending commands to aggregates
    Given my app is running
    When I send a command to an aggregate
    Then an event is raised
