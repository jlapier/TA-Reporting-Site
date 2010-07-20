# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def site_title
    @site_title = "TA Reporting"
  end
  
  def page_title
    if controller.controller_name == "user_sessions" or controller.action_name == "homepage"
      pt = ''
    else
      pt = "#{controller.controller_name.humanize}"
    end
    pt
  end
end
