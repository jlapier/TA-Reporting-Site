Feature: Clear image map cache after activity changes

  Background: I am logged in
    Given I am logged in as "test.user@test.com"
  
  Scenario: updating an activity
    Given I am on the edit activity page for "Activity One"
    And I fill in "Description" with "Changed Activity One"
    And I press "Save"
    Then I should see "Activity updated."
    And the summary map cache should be cleared
    
  Scenario: deleting an activity
    Given I am on the activities page
    When I follow "Delete" within "table#activities_table>tr.row_light"
    Then I should see "Activity deleted."
    And the summary map cache should be cleared