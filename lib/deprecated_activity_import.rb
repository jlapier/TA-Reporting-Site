module DeprecatedActivityImport
  def csv_headers
    [
      'Date',
      'Objective',
      'TA Delivery Method',
      'Intensity',
      'TA Categories',
      'Agencies',
      'States'
    ]
  end
  def csv_dump(headers)
    [
      date_of_activity,
      "#{objective.number}: #{objective.name}",
      ta_delivery_method.name,
      intensity_level.name,
      ta_categories.collect{|ta| ta.name}.join('; '),
      collaborating_agencies.collect{|a| a.name}.join('; '),
      states.collect{|s| "#{s.name} (#{s.abbreviation})"}.join('; ')
    ]
  end
  def npso_objective=(field_value)
    objective_legend = {
      :provide_ta => 'Provide TA',
      :knowledge_development => 'Knowledge Development'
    }
    objective_number, objective_name = field_value.split('.').collect{|s| s.strip}
    objective_name = objective_legend[objective_name.underscore.to_sym].nil? ? objective_name : objective_legend[objective_name.underscore.to_sym]
    objective = Objective.find_by_number(objective_number)
    logger.error("Missing Objective for '#{objective_number}' '#{objective_name}'. Total: #{Objective.count}") if objective.nil?
    self.objective = objective
  end
  def type_of_activity=(field_value)
    activity_type_legend = {
      :consultation_phone => 'Consult - Phone/email/in-person'
    }
    activity_type_name = field_value.strip
    activity_type_name = activity_type_name.blank? ? DEFAULT_IMPORT_TYPE : activity_type_name
    activity_type = ActivityType.find_by_lowercase_name(activity_type_name).first
    if activity_type.nil?
      activity_type_name = activity_type_legend[activity_type_name.gsub(" ", '').underscore.to_sym]
      activity_type = ActivityType.find_by_name(activity_type_name)
    end
    logger.error("Missing ActivityType for '#{activity_type_name.blank? ? 'field was blank' : activity_type_name}'. No alternate found in activity_type_legend using default: #{DEFAULT_IMPORT_TYPE}. Total: #{ActivityType.count}") if activity_type.nil?
    self.activity_type = activity_type.nil? ? ActivityType.find_or_create_by_name(DEFAULT_IMPORT_TYPE) : activity_type
  end
  def csv_states=(field_value)
    state_legend = {
      :fm => 'FSM'
    }
    legend_keys = state_legend.keys.collect{|k| k.to_s.upcase}
    state_abbreviations = field_value.split(' ').compact.collect{|s| s.gsub(/[^A-Z]/, '').strip.squeeze(" ")}.compact
    state_abbreviations.reject!{|s| s.blank?}
    if state_abbreviations.any?{|s| legend_keys.include?(s)}
      legend_keys.each do |key|
        if state_abbreviations.any?{|s| s == key}
          i = state_abbreviations.find_index(key)
          state_abbreviations[i] = state_legend[key.downcase.to_sym]
        end
      end
    end
    stored_state_count = State.count({
      :conditions => {
        :abbreviation => state_abbreviations
      }
    })
    if stored_state_count < state_abbreviations.size
      stored_states = State.find(:all, :select => 'abbreviation', :conditions => {:abbreviation => state_abbreviations}).compact
      stored_states = stored_states.collect{|s| s.abbreviation}.compact
      missing_states = state_abbreviations - stored_states
      unless missing_states.join(', ').blank?
        logger.error("Missing States: '#{missing_states.sort.join(', ')}' given '#{state_abbreviations.sort.join(', ')}' Total: #{State.count}\r\n\t#{State.just_states.collect{|s| "#{s.abbreviation} - #{s.name}"}.compact.join("\n\t")}")
      end
    end
    state_abbreviations.each do |state_abbrev|
      state = State.find_by_abbreviation(state_abbrev)
      logger.error("Missing State for: '#{state_abbrev}' (size: #{state_abbrev.size}) Total: #{State.count}\r\n\t#{State.just_states.collect{|s| "#{s.abbreviation} - #{s.name}"}.compact.join("\n\t")}") if state.nil?
      self.states << state unless state.nil? || !self.states.nil? && self.states.include?(state)
    end
  end
  # Import csv from legacy xls structure
  def self.legacy_csv_import(filepath)
    count = 0
    @@meta, @@headers = []
    FasterCSV.foreach(filepath) do |fields|
      count += 1
      next if count <= 2
      new_activity = Activity.new
      {
        1 => 'Date Activity Occurred',
        2 => 'NPSO Objective',
        3 => 'Type of Activity (cts)',
        10 => 'Description of Activity',
        11 => 'States'
      }.each do |column_index, header|
        next if fields[column_index].nil?
        #fields[column_index].gsub!(/[\s\t\n\r]{2,}/, " ")
        fields[column_index].squeeze!(" ")
        case header.strip
        when 'Date Activity Occurred'
          month, year = fields[column_index].split('-')
          month, day, year = fields[column_index-1].split('/') if month.nil? || year.nil?
          raise "No usable date found for:\r\n\t#{fields.join("\r\n\t")}" if month.nil? || year.nil?
          new_activity.date_of_activity = "#{month}-1-20#{year}".to_date unless day
          new_activity.date_of_activity = "#{month}-1-#{year}".to_date if day
        when 'NPSO Objective'
          new_activity.npso_objective = fields[column_index]
          if new_activity.objective.nil?
            raise "Missing objective: '#{fields[column_index]}' at #{count} (i: #{column_index})\r\nFields:\r\n\t#{fields.inspect}"
          end
        when 'Type of Activity (cts)'
          new_activity.type_of_activity = fields[column_index]
          if new_activity.activity_type_id.blank?
            raise "Missing activity type: #{fields[column_index]} at #{count} (i: #{column_index})\r\nFields:\r\n\t#{fields.inspect}"
          end
        when 'Description of Activity'
          new_activity.description = fields[column_index].strip
        when 'States'
          new_activity.csv_states = fields[column_index]
        end
      end
      # Avoid altering validations and set an intensity_level that's easy to update in batch
      new_activity.intensity_level = IntensityLevel.find_or_create_by_name(DEFAULT_IMPORT_INTENSITY)
      begin
        if new_activity.activity_type_id.blank?
          new_activity.activity_type = ActivityType.find_or_create_by_name(DEFAULT_IMPORT_TYPE)
        end
        if new_activity.description.blank?
          new_activity.description = "None found for import."
        end
        new_activity.save!
        logger.info("#{new_activity.date_of_activity.to_s} #{Activity.count} saved activities")
      rescue ActiveRecord::RecordInvalid => e
        raise "#{e.message}\r\nActivity (#{Activity.count}):\r\n\t#{new_activity.attributes.collect{|k,v| "#{k} => #{v}"}.join(",\r\n\t")}\r\nFields:\r\n\t#{fields.join("\r\n\t")}"
      end
    end
  end
  # def self.csv_load(meta, headers, fields)
  #   #meta.merge!({'class' => 'Activity'})
  #   activity_type_legend = {
  #     'Consultation - Phone' => 'Consult - Phone/email/in-person'
  #   }
  #   
  #   new_activity = Activity.new
  #   #raise "#{new_activity.inspect}"
  #   headers.each do |header|
  #     column_index = headers.find_index(header)
  #     #raise "#{header} is blank" if fields[column_index].blank?
  #   
  #     case header.strip
  #     when 'Date Activity Occurred'
  #       new_activity.date_of_activity = fields[column_index] #.to_date
  #     when 'NPSO Objective'
  #       objective_number, objective_name = fields[column_index].split('.')
  #       objective = Objective.find_by_name(objective_name.strip)
  #       if objective.nil?
  #         raise "Unable to locate objective for #{objective_number}: #{objective_name}"
  #       end
  #       new_activity.objective = objective
  #     when 'Type of Activity (cts)'
  #       activity_type_name = fields[column_index].strip
  #       if ActivityType.count(:conditions => {:name => activity_type_name}) < 1
  #         activity_type_name = activity_type_legend[activity_type_name]
  #       end
  #       activity_type = ActivityType.find_by_name(activity_type_name)
  #       if activity_type.nil?
  #         activity_type = ActivityType.find_by_name(activity_type_legend[activity_type_name])
  #         raise "Unable to locate activity type for #{activity_type_name}"
  #       end
  #       new_activity.activity_type = activity_type
  #     when 'Description of Activity'
  #       new_activity.description = fields[column_index].strip
  #     when 'States'
  #       state_abbreviations = fields[column_index].split(' ').compact
  #       stored_state_count = State.count({:conditions => {:abbreviation => state_abbreviations}})
  #       if stored_state_count < state_abbreviations.size
  #         stored_states = State.find(:all, :select => 'abbreviation', :conditions => {:abbreviation => state_abbreviations})
  #         stored_states = stored_states.collect{|s| s.abbreviation}
  #         missing_states = state_abbreviations - stored_states
  #         raise "Unable to locate these states given these abbreviations: #{missing_states.join(' ')}"
  #       end
  #       fields[column_index].split(' ').each do |state_abbrev|
  #         state = State.find_by_abbreviation(state_abbrev)
  #         new_activity.states << state unless !new_activity.states.nil? && new_activity.states.include?(state)
  #       end
  #     end
  #   end
  #   new_activity.save
  #   return new_activity
  # end
end