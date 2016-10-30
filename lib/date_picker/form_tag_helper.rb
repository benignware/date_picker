require 'erb'
require 'tzinfo'
module DatePicker
  module FormTagHelper
    
    def date_picker_tag(name, value, options = {}, html_options = nil)

      # Clean object and attribute names
      object_name = name.gsub(/\[\w*\]$/, "")
      attribute_name = name.gsub(/.*\[(\w*)\]$/, "\\1")
      
      # Setup Options      
      option_names = [:time_zone, :format, :type, :default, :min, :max]
      opts = options.clone
      html_opts = html_options.clone
      options||= {}
      options = opts.slice(*option_names)
      options = ({
        type: :date,
        time_zone: false,
      }).merge(options)
      html_options||= {}

      # Merge html_options with options
      html_options = {
        # Use text-type as default instead of date, since Datepicker should not mix up with native html5 components
        type: :text,
        # Generate unique ID with UI
        id: "date_picker_" + Digest::SHA1.hexdigest(name.to_s)[8..16],
        name: name,
        data: html_options[:data] || options[:data] || {}
      }.merge(opts.except(*option_names)).merge(html_options)
      
      # Get the type
      type = options[:type]
      
      # Set default values
      if !options.key?(:default)
        case type
          when :date
            default = Date.current
          when :datetime
            default = DateTime.current
          when :time
            default = Time.current
        end
      else
        default = options[:default]
      end
      
      # Override value from html_options
      if html_options.key?(:value)
        value = html_options[:value]
      end
      
      # Set default value if blank
      if value.blank?
        value = default
      end
      
      # Get Type format if not specified
      format = nil
      if options[:format].present?
        format = options[:format]
      elsif DatePicker.config.formats.present?
        format = DatePicker.config.formats[type]
      end
      
      # Apply string format identifier or default format
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
      
      # Get Style
      if options[:style].present?
        style = options[:style]
      elsif DatePicker.config.style.present?
        style = DatePicker.config.style
      else
        style = :none
      end
      path = File.join(File.dirname(__FILE__), "styles", style.to_s)

      # Require the selected style and retrieve as object
      if style && style != 'none' && File.exist?(path + '.rb')
        require path
        obj = Object::const_get('DatePicker::Styles::' + style.to_s.classify).new
      end
      
      # Merge with types and options from style template
      types = [:date]
      if obj && obj.respond_to?(:types)
        types = obj.send(:types)
      end
      
      # Mobile Fallback
      is_mobile = (request.headers["HTTP_USER_AGENT"].present? && request.headers["HTTP_USER_AGENT"] =~ /\b(Mobile|webOS|Android|iPhone|iPad|iPod|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i).present?
      if is_mobile
        case options[:type]
        when :date
          return date_field(object_name, attribute_name, html_options.merge({type: 'date', value: value.present? ? value : ''}))
        when :datetime
          return datetime_field(object_name, attribute_name, html_options.merge({type: 'datetime-local', value: value.present? ? value.strftime("%Y-%m-%dT%H:%M:%S") : ''}))
        when :time
          return time_field(object_name, attribute_name, html_options.merge({type: 'time', value: value.present? ? value.strftime("%H:%M") : ''}))
        end
      end

      # Desktop Fallback
      if !obj || !types.include?(options[:type])
        # Presence of attribute name prevents auto-generating        
        html_options.delete(:name)
        # Choose the right form helper by type
        case options[:type]
        when :date
          return date_select(object_name, attribute_name, {default: value}, html_options)
        when :datetime
          return datetime_select(object_name, attribute_name, {default: value}, html_options)
        when :time
          return time_select(object_name, attribute_name, {default: value}, html_options)
        end
      end

      # Get options from implementation
      if obj.respond_to?(:options)
        html_options = html_options.merge(obj.send(:options))
      end
      
      # Get mapping from style
      if obj.mapping.present?
        mapping = obj.mapping
      end
      
      # Resolve mapping by identifier
      if obj.mapping.is_a? Symbol
        mapping = DatePicker::Mappings.send(obj.mapping)
      end

      # Setup picker format
      picker_format = format.clone

      # Escape special chars in format
      if mapping[:__].present?
        replace = mapping[:__].gsub(/\*/, "\\\\1")
        # Get strftime patterns
        keys = mapping.keys.select{ |key| !mapping[key].blank? && !key.to_s.start_with?('__') }
        # Get picker patterns
        values = keys.map{ |key| mapping[key] }
        # Escape any special characters of picker format not preceded by %
        picker_format.gsub!(/(?<!%)(#{(values.map { |string| Regexp.escape(string) }).join('|')})/i, replace)
        # Escape strftime patterns not preceded by %
        picker_format.gsub!(/(?<!%)(#{(keys.map { |string| Regexp.escape(string) }).join('|')})/i, replace)
      end
      
      # If time_zone option is specified, replace timezone identifier with mapping in format
      if options[:time_zone]
        # Time zone abbreviation name
        picker_format.gsub!("%Z", value.present? ? value.to_datetime.strftime("%Z") : "")
        # Time zone as hour and minute offset from UTC (e.g. +0900)
        picker_format.gsub!("%z", mapping[:z])
      else
        # Otherwise strip time zone and trim result
        picker_format.gsub!("%Z", "")
        picker_format.gsub!("%z", "")
        picker_format.strip!
      end
      
      # Actually replace patterns
      mapping.each_pair do |k, v|
        picker_format.gsub!("%" + k.to_s, v)
      end
      
      # Setup data format pattern
      if type == :date
        data_format = "%Y-%m-%d"
      else
        data_format = "%Y-%m-%d %H:%M:%S" + ((format.include?("%z") || format.include?("%z")) && options[:time_zone] ? ' %z' : '')
      end
      
      # If time_zone option is specified, replace timezone identifier with mapping in data_format
      if options[:time_zone]
        # Time zone abbreviation name
        data_format.gsub!("%Z", value.present? ? value.to_datetime.strftime("%Z") : "")
        # Time zone as hour and minute offset from UTC (e.g. +0900)
        data_format.gsub!("%z", mapping[:z])
      end
      
      # Replace mappings in data_format
      mapping.each_pair do |k, v|
        data_format.gsub!("%" + k.to_s, v)
      end

      # Get formatted value
      formatted_value = value.present? ? I18n.l(value, format: format.to_s) : nil
      html_options[:value] = formatted_value

      # Get builder template reference
      tmpl = obj.template
      
      # i18n
      locale = I18n.locale
      month_names = I18n.t('date.month_names', default: '')
      month_names = month_names.present? ? month_names.slice(1, month_names.length - 1) : Date::MONTHNAMES
      abbr_month_names = I18n.t('date.abbr_month_names', default: '')
      abbr_month_names = abbr_month_names.present? ? abbr_month_names.slice(1, abbr_month_names.length - 1) : Date::MONTHNAMES
      day_names = I18n.t('date.day_names', default: Date::DAYNAMES)
      abbr_day_names = I18n.t('date.abbr_day_names', default: Date::ABBR_DAYNAMES)
      
      # Setup timestamp
      time = value.present? ? value.to_time.utc.to_i * 1000 : 0
      
      # Setup timezone
      tz = Time.zone
      if value.present?
        utc_offset = (value.is_a?(Date) ? value.to_datetime : value).utc_offset
        tz = ActiveSupport::TimeZone.all.select {
          |zone|
          zone.tzinfo.current_period.offset.utc_total_offset === utc_offset
        }.first
      end
      timezone = type === :time && utc_offset === 0 ? 'Etc/UTC' : ActiveSupport::TimeZone::MAPPING[tz.name]
      
      # Setup Picker Options
      camelized_keys = 
        lambda do |h| 
          Hash === h ? 
            Hash[
              h.map do |k, v| 
                key = k.to_s().camelize
                key = key[0, 1].downcase + key[1..-1]
                [key, camelized_keys[v]] 
              end 
            ] : h 
        end
        
      picker_options = camelized_keys[html_options[:data]].to_json
      
      # Setup html input
      input_tag = :input
      input_id = html_options[:id]
      input_html = content_tag(input_tag, nil, html_options)
      
      # Setup template variables
      vars = options.merge({
        type: type,
        value: value,
        locale: locale,
        picker_format: picker_format,
        data_format: data_format,
        name: name,
        input_id: input_id,
        html_options: html_options,
        time: time,
        time_zone: timezone,
        input_html: input_html, 
        month_names: month_names,
        abbr_month_names: abbr_month_names,
        day_names: day_names,
        abbr_day_names: abbr_day_names
      })
      
      # Actually render the picker
      result = ERB.new(tmpl).result(OpenStruct.new(vars).instance_eval { binding })
      
      # Return picker html
      return result.html_safe
      
    end
    
    def datetime_picker_tag(name, value, options = {}, html_options = {})
      options = options.clone.merge({
        type: :datetime
      })
      date_picker_tag(name, value, options, html_options)
    end
    
    def time_picker_tag(name, value, options = {}, html_options = {})
      options = options.clone.merge({
        type: :time
      })
      date_picker_tag(name, value, options, html_options)
    end
    
  end
  
end