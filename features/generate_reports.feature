Feature: Generate reports
  In order to meet grant requirements
  I want to export reports on activities, saving the export rules
  
  Background:
    Given I am logged in as "test.user@test.com"

  Scenario: create a set of rules by which to generate a report from
    Given I am on the new report page
    When I fill in "Name" with "Q1 - 2010"
    And I press "Create Report"
    Then I should see "New Report successfully created."
    And I should be on the edit report page for "Q1 - 2010"
    
  Scenario: create a summary report
    Given I am on the new summary report page
    When I fill in "Name*" with "Full Year 2010 - Evaluation"
    And I fill in "Start ytd*" with "01/01/2011"
    And I fill in "Start period" with "03/01/2011"
    And I fill in "End period" with "03/30/2011"
    And I select "1: Knowledge Development" from "Objective"
    And I press "Create Summary report"
    Then I should see "Summary Report was successfully created."
    
  @javascript
  Scenario: add report breakdowns
    Given I am on the edit report page for "Q2 - 2010"
    When I select "1: Knowledge Development" from "Objective"
    And I select "TA Delivery Method" from "Breakdown type"
    And I check "Include states"
    And I press "Add"
    Then I should see "1: Knowledge Development" within "#report_breakdowns"
