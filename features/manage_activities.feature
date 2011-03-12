Feature: Manage activities
  In order to report on grant-related activities
  I want to record and update activity info
  
  Background:
    Given I am logged in as "test.user@test.com"

  Scenario: delete an activity
    Given I am on the activities page
    When I follow "Delete" within "table#activities_table>tbody>tr.row_light"
    Then I should see "Activity deleted."

  @javascript
  Scenario: record a new activity
    Given I am on the new activity page
    When I select "2011" from "activity_date_of_activity_1i"
    And I select "July" from "activity_date_of_activity_2i"
    And I select "23" from "activity_date_of_activity_3i"
    And I select "2: Provide TA" from "Objective"
    Then I should not see "Core Meetings"
    And I should not see "Assessing technical adequacy of Indicator 14 data collection methods"
    When I check "Budget Management"
    And I check "Advisory Committee"
    And I select "Consult - onsite" from "Ta delivery method"
    And I select "Targeted/Specific" from "Intensity level"
    And I fill in "Description" with "Troubleshoot and re-configure email client."
    And I check "Graduation rates"
    And I check "Regional Resource Center Program"
    And I check "Oregon"
    And I press "Create Activity"
    Then I should see "New Activity successfully saved."
    And I should be on the activities page
  
  @javascript 
  Scenario: record a new activity with an as yet unrecorded TA Category
    Given I am on the new activity page
    When I select "2011" from "activity_date_of_activity_1i"
    And I select "July" from "activity_date_of_activity_2i"
    And I select "23" from "activity_date_of_activity_3i"
    And I select "1: Knowledge Development" from "Objective"
    Then I should not see "Budget Management"
    And I should not see "Advisory Committee"
    When I check "Core Meetings"
    And I check "Assessing technical adequacy of Indicator 14 data collection methods"
    And I select "Consult - onsite" from "Ta delivery method"
    And I select "Targeted/Specific" from "Intensity level"
    And I fill in "Description" with "Troubleshoot and re-configure email client."
    And I check "Graduation rates"
    And I check "Other"
    And I fill in "New TA Category" with "Efficacy ratings"
    And I check "Regional Resource Center Program"
    And I check "Oregon"
    And I press "Create Activity"
    Then I should see "New Activity successfully saved."
    And I should be on the activities page