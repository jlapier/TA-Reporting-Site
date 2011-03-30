module MapController
private
  def map_for(type=:period)
    case type
    when :period
      filename = 'summary_map.png'
      cache_path = summary_map_report_path(@report, :format => :svg)
    when :ytd
      filename = 'ytd_map.png'
      cache_path = ytd_map_report_path(@report, :format => :svg)
    else
      raise ArgumentError, "unknown map type"
    end
    
    svgxml = render_to_string('reports/map')
    
    cache_map(svgxml, cache_path)
    send_png(filename, svgxml)
  end
  def send_png(filename, svg)
    il = Magick::ImageList.new
    il.from_blob(svg)
    sizedil = il.resize_to_fit(315,300)
    sizedil.format = "PNG"
    send_data(sizedil.to_blob, :filename => filename) and return
  end
  def cache_map(map, path)
    full_path = File.join(Rails.root, "public", path)
    dir = File.dirname(full_path)
    logger.debug("dirname - #{dir}")
    FileUtils.mkdir_p(dir)
    file = File.new(full_path, "w+")
    file << map
    file.close
  end
  def load_states_for(type=:ytd)
    activities = type == :ytd ? @search.ytd_activities : @search.activities
    
    @intensity_levels = IntensityLevel.order('number')
    @states = {}
    @intensity_levels.each do |il|
      il_activities = activities.where(:intensity_level_id => il)
      @states[il.id] = @search.summary_report.
                            states_for(il_activities, :abbreviated => false)
    end
  end
end