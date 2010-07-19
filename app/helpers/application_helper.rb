# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def site_title
    "TA Activity Reports"
  end

  def logo_image
    image_tag(site_logo)
  end

  def site_logo
    "GenericLogo.png"
  end
  
  def page_title
    if controller.controller_name == "user_sessions" or controller.action_name == "home"
      pt = ''
    else
      pt = "#{controller.controller_name.humanize}"
    end
    pt
  end

  def site_footer
    @site_footer ||= SiteSetting.read_setting('site footer') ||
      "Content on this site is the copyright of the owners of #{request.host} and is provided as-is without warranty."
  end
end
