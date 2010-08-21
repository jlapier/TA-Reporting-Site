Feature: Manage activities
  In order to report on grant-related activities
  I want to record and update activity info
  
  Background:
    Given I am logged in as "test.user@test.com"
  
  Scenario: record a new activity
    Given I am on the new activity page
    When I fill in "Date of activity" with "July 23, 2010"
    And I select "2: Provide TA" from "Objective"
    And I select "Consult - onsite" from "Activity type"
    And I select "Targeted/Specific" from "Intensity level"
    And I fill in "Description" with "Troubleshoot and re-configure email client."
    And I check "Graduation rates"
    And I check "Regional Resource Center Program"
    And I check "Oregon"
    And I press "Save"
    Then I should see "New Activity successfully saved."
    And I should be on the activities page
    
  Scenario: delete an activity
    Given I am on the activities page
    When I follow "Delete" within "table#activities_table>tr.row_light"
    Then I should see "Activity deleted."
  
  @javascript 
  Scenario: record a new activity with an as yet unrecorded TA Category
    Given I am on the new activity page
    When I fill in "Date of activity" with "July 23, 2010"
    And I select "2: Provide TA" from "Objective"
    And I select "Consult - onsite" from "Activity type"
    And I select "Targeted/Specific" from "Intensity level"
    And I fill in "Description" with "Troubleshoot and re-configure email client."
    And I check "Graduation rates"
    And I check "Other"
    And I fill in "New TA Category" with "Efficacy ratings"
    And I check "Regional Resource Center Program"
    And I check "Oregon"
    And I press "Save"
    Then I should see "New Activity successfully saved."
    And I should be on the activities page