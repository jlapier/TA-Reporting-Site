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
   
  Scenario Outline: use dates and select options to filter activities
    Given I select "<value>" from "<target>"
    And I press "search"
    Then I should see "<date>"
    And I should see "<grant_activity>"
    And I should see "<intensity_level>"
    Examples:
      | target          | value                 | date     | grant_activity                              | intensity_level   |
      | Objective       | Knowledge Development | 02/01/11 | Product development/revision                | General/Universal |
      | Delivery        | Conference            | 02/18/11 | Provide general TA to States to assist them | General/Universal |
      | Intensity Level | Targeted              | 02/23/11 |                                             | Targeted/Specific |
      | Grant Activity  | Product development   | 02/01/11 | Product development/revision                | General/Universal |

  Scenario Outline: use dates and keywords to filter activities
    Given I fill in "Keywords" with "<keywords>"
    And I press "search"
    Then I should see "<date>"
    And I should see "<grant_activity>"
    And I should see "<intensity_level>"
    Examples:
      | keywords         | date     | grant_activity                              | intensity_level   |
      | Data Use Toolkit | 02/01/11 | Product development/revision                | General/Universal |
      | OAVSNP           | 02/18/11 | Provide general TA to States to assist them | General/Universal |
      | New Mexico       | 02/23/11 |                                             | Targeted/Specific |
      | Toolkit          | 02/01/11 | Product development/revision                |                   |

  Scenario Outline: use select options alone to filter activities      
    When I select "" from "activity_search_start_date_1i"
    And I select "" from "activity_search_start_date_2i"
    And I select "" from "activity_search_start_date_3i"
    And I select "" from "activity_search_end_date_1i"
    And I select "" from "activity_search_end_date_2i"
    And I select "" from "activity_search_end_date_3i"
    And I select "<value>" from "<target>"
    And I press "search"
    Then I should see "<date>"
    And I should see "<grant_activity>"
    And I should see "<intensity_level>"
    Examples:
      | target          | value                | date     | grant_activity               | intensity_level   |
      | Objective      | Knowledge Development | 02/01/11 | Product development/revision | General/Universal |
      | Grant Activity | Product development   | 02/01/11 | Product development/revision | General/Universal |
