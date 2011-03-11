Feature: Search activities

  Background:
    Given I am logged in as "test.user@test.com"
    And I am on the activities page
    And I select "2011" from "activity_search_start_date_1i"
    And I select "February" from "activity_search_start_date_2i"
    And I select "1" from "activity_search_start_date_3i"
    And I select "2011" from "activity_search_end_date_1i"
    And I select "February" from "activity_search_end_date_2i"
    And I select "28" from "activity_search_end_date_3i"
    
  Scenario Outline:
    Given I select "<objective>" from "Objective"
    And I select "<delivery>" from "Ta delivery method"
    And I select "<intensity_level>" from "Intensity level"
    And I select "<grant>" from "Grant activity"
    And I fill in "Keywords" with "<keywords>"
    And I press "search"
    Then I should see "<date>"
    And I should see "<grant_activity>"
    And I should see "<intensity>"
    Examples:
      | objective             | delivery   | intensity_level | grant               | keywords         | date     | grant_activity                              | intensity         |
      | Knowledge Development |            |                 |                     | Data Use Toolkit | 02/01/11 | Product development/revision                | General/Universal |
      |                       | Conference |                 |                     | OAVSNP           | 02/18/11 | Provide general TA to States to assist them | General/Universal |
      |                       |            | Targeted        |                     | New Mexico       | 02/23/11 |                                             | Targeted/Specific |
      |                       |            |                 | Product development | Toolkit          | 02/01/11 | Product development/revision                |                   |
