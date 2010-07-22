@javascript
Feature: Auto complete objective name
  
  Scenario: creating a new activity w/ an existing objective
    Given I am on the new activity page
    When I fill in "Objective" with "Know"
    Then I should see "Knowledge development"
