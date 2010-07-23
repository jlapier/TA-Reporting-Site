Feature: Generate reports
  In order to meet grant requirements
  I want to export reports on activities, saving the export rules

  Scenario: create a set of rules by which to generate a report from
    Given I am on the new report page
    When I fill in "Name" with "Q1 - 2010"
    And I check "Include descriptions"
    And I check "Provide TA" within "#objective_options"
    And I check "Leadership and Coordination" within "#objective_options"
    And I check "Information request" within "#activity_type_options"
    And I check "Consult - Phone/email/in-person" within "#activity_type_options"
    And I check "Consult - onsite" within "#activity_type_options"
    And I check "Any" within "#levels_of_intensity_options"
    And I fill in "Begin date" with "January 1, 2010"
    And I fill in "End date" with "March 31, 2010"
    And I press "Preview"
    Then I should see "Preview of Report: Q1 - 2010"
