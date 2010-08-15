@javascript
Feature: Update imported activities

  Background:
    Given I am logged in as "test.user@test.com"
    
  Scenario: update an activity
    Given I am on the edit all activities page
    When I select "1" from "Objective" within "tr.row_light"
    And I select "Information request" from "Activity type" within "tr.row_light"
    And I select "General/Universal" from "Intensity level" within "tr.row_light"
    And I press "Update" within "tr.row_light"
    Then I should be on the edit all activities page  
  