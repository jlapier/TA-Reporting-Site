@javascript
Feature: Manage activities
  In order to report on grant-related activities
  I want to record and update activity info
  
  Scenario: record a new activity
    Given I am on the new activity page
    When I fill in "Date of activity" with "July 23, 2010"
    And I select "Provide TA" from "Objective"
    And I select "Consult - onsite" from "Activity type"
    And I select "Targeted/Specific" from "Intensity level"
    And I fill in "Description" with "Troubleshoot and re-configure email client."
    And I check "Graduation rates"
    And I check "Regional Resource Center Program"
    And I check "Oregon"
    And I press "Save"
    Then I should see "New Activity successfully saved."
    And I should be on the new activity page
 
