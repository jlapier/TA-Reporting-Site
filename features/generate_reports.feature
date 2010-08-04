Feature: Generate reports
  In order to meet grant requirements
  I want to export reports on activities, saving the export rules
  
  Background:
    Given I am logged in as "test.user@test.com"

  Scenario: create a set of rules by which to generate a report from
    Given I am on the new report page
    When I fill in "Name" with "Q1 - 2010"
    And I press "Save changes"
    Then I should see "New Report successfully created."
    And I should be on the edit report page for "Q1 - 2010"
    
  Scenario: export a report
    Given I am on the reports page
    When I follow "preview" within "#report_1"
    Then I should see "Previewing Q1 - 2010"
    
  @javascript
  Scenario: add report breakdowns
    Given I am on the edit report page for "Q2 - 2010"
    When I select "1: Knowledge development" from "Objective"
    And I select "Activity Type" from "Breakdown type"
    And I check "Include states"
    And I press "Add"
    Then I should see "1: Knowledge development" within "#report_breakdowns"