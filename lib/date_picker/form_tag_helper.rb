require 'erb'
module DatePicker
  module FormTagHelper
    
    def date_picker_tag(name, value, options = {})

      options[:type]||= :date
      options[:time_zone]||= false
      options[:data]||= {}
      options[:id]||= "date_picker_" + Digest::SHA1.hexdigest(name.to_s)[8..16]
      
      type = options[:type]
      
      if value.blank?
        case type
          when :date
            value = Date.today
          when :datetime
            value = DateTime.now
          when :time
            value = Time.now
        end
      end
      
      # Get Type format if not specified
      if options[:format].present?
        format = options[:format]
      else
        format = DatePicker.config.formats[type]
      end
      if format.blank? || !format.is_a?(String)
        case type
          when :date
            format_id = format.present? && format.is_a?(Symbol) ? format.to_s : 'default'
            format = I18n.t('date.formats.' + format_id, default: "%Y-%m-%d")
          when :datetime
            format_id = format.present? && format.is_a?(Symbol) ? format.to_s : 'default'
            format = I18n.t('time.formats.' + format_id, default: "%a, %d %b %Y %H:%M:%S")
          when :time
            format_id = format.present? && format.is_a?(Symbol) ? format.to_s : 'only_time'
            format = I18n.t('time.formats.' + format_id, default: "%H:%M:%S")
        end
      else
        format = format.to_s
      end
      
      if options[:style].present?
        style = options[:style]
      elsif DatePicker.config.style.present?
        style = DatePicker.config.style
      else
        style = :bootstrap
      end
      
      path = File.join(File.dirname(__FILE__), "styles", style.to_s)
      
      require path
      
      obj = Object::const_get('DatePicker::Styles::' + style.to_s.classify).new
      
      
      types = [:date]
      if obj.respond_to?(:types)
        types = obj.send(:types)
      end
      
      formatted_value = value.present? ? value.strftime(format) : nil
      
      input_options = options.except(:time_zone, :format, :input_tag, :type, :pattern)
      
      if obj.respond_to?(:options)
        input_options = input_options.merge(obj.send(:options))
      end
      
      if obj.mapping.present?
        mapping = obj.mapping
      end

      if obj.mapping.is_a? Symbol
        mapping = DatePicker::Mappings.send(obj.mapping)
      end
      
      input_options[:type] = :text
      input_options[:value] = formatted_value
      
      input_tag = options[:tag] || :input
      input_id = options[:id]
      input_html = content_tag(input_tag, nil, input_options)

      # Escape special chars
      if mapping[:_].present?
        format.gsub!(/(?<!%)([a-z]+)/i, mapping[:_].gsub(/\*/, "\\\\1"))
      end
      
      if options[:time_zone]
        # Time zone abbreviation name
        format.gsub!("%Z", value.present? ? value.to_datetime.strftime("%Z") : "")
        # Time zone as hour and minute offset from UTC (e.g. +0900)
        format.gsub!("%z", mapping[:z])
      else
        # Strip time zone and trim result
        format.gsub!("%Z", "")
        format.gsub!("%z", "")
        format.strip!
      end
      
      mapping.each_pair do |k, v|
        format.gsub!("%" + k.to_s, v)
      end
      
      # Set up the data format pattern
      if type == :date
        data_format = "%Y-%m-%d"
      else
        data_format = "%Y-%m-%d %H:%M:%S %z"
      end
      
      if options[:time_zone]
        # Time zone abbreviation name
        data_format.gsub!("%Z", value.present? ? value.to_datetime.strftime("%Z") : "")
        # Time zone as hour and minute offset from UTC (e.g. +0900)
        data_format.gsub!("%z", mapping[:z])
      else
        # Strip time zone and trim result
        # Strip time zone and trim result
        format.gsub!("%Z", "")
        format.gsub!("%z", "")
        format.strip!
      end
      
      mapping.each_pair do |k, v|
        data_format.gsub!("%" + k.to_s, v)
      end
      
      object_name = name.gsub(/\[\w*\]$/, "")
      attribute_name = name.gsub(/.*\[(\w*)\]$/, "\\1")
      
      
      is_mobile = (request.headers["HTTP_USER_AGENT"].present? && request.headers["HTTP_USER_AGENT"] =~ /\b(Mobile|webOS|Android|iPhone|iPad|iPod|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i).present?
      
      # Mobile fallback
      if is_mobile
        case options[:type]
        when :date
          return date_field(object_name, attribute_name, input_options.merge({type: 'date', value: value}))
        when :datetime
          return datetime_field(object_name, attribute_name, input_options.merge({type: 'datetime-local', value: value.strftime("%Y-%m-%dT%H:%M:%S")}))
        when :time
          return time_field(object_name, attribute_name, input_options.merge({type: 'time', value: value.strftime("%H:%M")}))
        end
      end
      
      # Desktop Fallback
      if !types.include?(options[:type])
        case options[:type]
        when :date
          return date_select(object_name, attribute_name, {default: value}, input_options)
        when :datetime
          return datetime_select(object_name, attribute_name, {default: value}, input_options)
        when :time
          return time_select(object_name, attribute_name, {default: value}, input_options)
        end
      end
      
      # Use type text on desktop
      input_options[:type] = :text
      
      
      tmpl = obj.template
      
      # i18n
      locale = I18n.locale
      month_names = I18n.t('date.month_names', default: '')
      month_names = month_names.present? ? month_names.slice(1, month_names.length - 1) : Date::MONTHNAMES
      abbr_month_names = I18n.t('date.abbr_month_names', default: '')
      abbr_month_names = abbr_month_names.present? ? abbr_month_names.slice(1, abbr_month_names.length - 1) : Date::MONTHNAMES
      day_names = I18n.t('date.day_names', default: Date::DAYNAMES)
      abbr_day_names = I18n.t('date.abbr_day_names', default: Date::ABBR_DAYNAMES)
      
      time = value.present? ? value.to_datetime.utc.to_i * 1000 : 0
      
      camelized_keys = 
        lambda do |h| 
          Hash === h ? 
            Hash[
              h.map do |k, v| 
                puts k
                key = k.to_s().camelize
                key = key[0, 1].downcase + key[1..-1]
                [key, camelized_keys[v]] 
              end 
            ] : h 
        end
      
      json_options = camelized_keys[input_options[:data]].to_json
      
      vars = {
        type: type,
        value: value,
        locale: locale,
        format: format,
        data_format: data_format,
        name: name,
        input_id: input_id,
        input_options: input_options,
        time: time,
        input_html: input_html, 
        month_names: month_names,
        abbr_month_names: abbr_month_names,
        day_names: day_names,
        abbr_day_names: abbr_day_names
      }
      
      result = ERB.new(tmpl).result(OpenStruct.new(vars).instance_eval { binding })
      
      return result.html_safe
      
    end
    
    def datetime_picker_tag(name, value, options = {})
      options[:type]||= :datetime
      date_picker_tag(name, value, options)
    end
    
    def time_picker_tag(name, value, options = {})
      options[:type]||= :time
      datetime_picker_tag(name, value, options)
    end
    
  end
  
end