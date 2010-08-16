Feature: Download reports

  Background: When previewing a report
    Given this test causes 500 server error it is pending, though feature works in browser - same error occurs when running the summary_reports/show_spec via rake spec:rcov but no other times
    Given I am logged in as "test.user@test.com"
    And I am on the reports page
    When I select "Summary Report" from "summary_report_id" within "#report_q2-2010_dates"
    And I press "Preview"
    Then I should be on the report page for "Q2 - 2010"
    
  Scenario: Download CSV
    When I follow "Download CSV"
    Then I should not see "No activity has been recorded to satisfy the reporting period."
    And I should not see "Only CSV and PDF downloads are available."
    And I should be on the report page for "Q2 - 2010"
      
  Scenario: Download PDF
    When I follow "Download PDF"
    Then I should not see "No activity has been recorded to satisfy the reporting period."
    And I should not see "Only CSV and PDF downloads are available."
    And I should be on the report page for "Q2 - 2010"