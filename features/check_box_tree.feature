@javascript
Feature: Collapsible check box tree
  In order to quickly find and select from over 50 checkbox options
  I want to have options operate in sensical, compact groups
  
  Background:
    Given I am logged in as "test.user@test.com"
    And I go to the new activity page.
  
  Scenario: checking a parent automatically checks its children
    When I check "Western"
    Then the "Oregon" checkbox should be checked
    
  Scenario: checking a child automatically checks its parent
    When I check "Oregon"
    Then the "Western" checkbox should be checked
    
  Scenario: unchecking a parent automatically unchecks its children
    When I check "Western"
    And I uncheck "Western"
    Then the "Oregon" checkbox should not be checked
    
  Scenario: unchecking the last checked child unchecks its parent
    When I check "Oregon"
    And I uncheck "Oregon"
    Then the "Western" checkbox should not be checked