module MapController
private
  def build_map_url_for(report, search, path_opts={}, type=:period)
    path_opts[:format] ||= :png
    activities = type == :ytd ? search.ytd_activities : search.activities
    
    IntensityLevel.order('number').each do |intensity_level|
      key = ActivityMap::COLORS[intensity_level.number][:label]
      conditions = {:intensity_level_id => intensity_level.id}
      
      path_opts[key] = @search.summary_report.
        states_for(activities.where(conditions)).map(&:abbreviation).join('-')
      path_opts[key] = 'none' if path_opts[key].blank?
    end
    
    map_report_path(report, path_opts)
  end
  
  def send_png(filename, svg)
    il = Magick::ImageList.new
    il.from_blob(svg)
    sizedil = il.resize_to_fit(315,300)
    sizedil.format = "PNG"
    blob = sizedil.to_blob
    
    cache_page(blob, request.path)
    send_data(blob, :filename => filename) and return
  end
  
  def cache_and_send_map
    filename = 'map.png'    
    cache_path = request.path.gsub('.png', '.svg')
    svgxml = render_to_string('reports/map')
    
    cache_page(svgxml, cache_path)
    send_png(filename, svgxml)
  end
end
