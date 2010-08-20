Feature: Manage criteria

  Background:
    Given I am logged in as "test.user@test.com"
    
  Scenario: creating a new criterium does not set criterium type properly
    Given I am on the new criterium page
    When I select "Level of Intensity" from "Kind"
    And I fill in "Name" with "Hello"
    And I fill in "Description" with "develop practical, efficient..."
    And I press "Create Criterium"
    Then the "criterium" with a "name" of "Hello" should have a "Type" of "IntensityLevel"
    And the "criterium" with a "name" of "Hello" should have a "Description" of "develop practical, efficient..."