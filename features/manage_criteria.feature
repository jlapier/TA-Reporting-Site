Feature: Manage criteria

  Background:
    Given I am logged in as "test.user@test.com"
    
  Scenario: creating a new criterium does not set criterium type properly
    Given I am on the new criterium page
    When I select "Level of Intensity" from "Kind"
    And I fill in "Name" with "Hello"
    And I fill in "Description" with "develop practical, efficient..."
    And I press "Create Criterium"
    Then the "criterium" with a "name" of "Hello" should have a "Type" of "IntensityLevel"
    And the "criterium" with a "name" of "Hello" should have a "Description" of "develop practical, efficient..."
    
  Scenario: update intensity level criterium
    Given I am on the criteria page
    When I follow "Edit" within "div#intensity_level>div.configurable:first-child>div.configurable_links"
    And I fill in "Name" with "Updated Intensity Level"
    And I press "Update Intensity level"
    Then I should see "Intensity Level updated."