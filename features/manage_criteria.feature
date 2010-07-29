Feature: Manage criteria

  Background:
    Given I am logged in as "test.user@test.com"
    
  Scenario: creating a new criterium does not set criterium type properly
    Given I am on the new criterium page
    When I select "Level of Intensity" from "Kind"
    And I fill in "Name/description" with "Hello"
    And I press "Create Criterium"
    Then the "criterium" with a "name" of "Hello" should have a "Type" of "IntensityLevel"