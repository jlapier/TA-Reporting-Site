Feature: Manage users

  Background:
    Given I am logged in as "test.user@test.com"

  Scenario: create a new user
    Given I am on the new user page
    When I fill in "Email" with "johnny@test.com"
    And I fill in "Password" with "secret384"
    And I fill in "Password confirmation" with "secret384"
    And I press "Save"
    Then I should see "Account registered!"
    And I should be on the users page
  
  
  