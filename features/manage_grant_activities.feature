Feature: Manage grant activities

  Background:
    Given I am logged in as "test.user@test.com"
  
  Scenario: create a new grant activity, assigning 2 objectives
    Given I am on the new criterium page
    When I select "Grant Activity" from "Kind"
    And I fill in "Name" with "New Grant Activity"
    And I fill in "Description" with "Summary text."
    And I press "Create Criterium"
    Then I should see "Grant Activity saved. You can assign this Grant Activity to Objectives to help trim selectable options when recording Activities."
    And I should be on the edit criterium page for "New Grant Activity"
    When I check "Leadership and Coordination"
    And I check "Evaluate and Manage (includes Advisory)"
    And I press "Update Grant activity"
    Then I should see "Grant Activity updated."