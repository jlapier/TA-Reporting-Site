module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the login page/
      '/user_session/new'
      
    when /the new activity page/
      new_activity_path
      
    when /the activities page/
      activities_path
      
    when /the edit activity page for "(.*)"/
      edit_activity_path(Activity.find_by_description($1))
      
    when /the report page for "(.*)"/
      report_path(Report.find_by_name($1))
      
    when /the edit report page for "(.*)"/
      edit_report_path(Report.find_by_name($1))
      
    when /the new criterium page/
      new_criterium_path
      
    when /the edit criterium page for "(.*)"/
      edit_criterium_path(Criterium.find_by_name($1))

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
