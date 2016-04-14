module DatePicker
  module FormHelper
    
    def self.field_id(object_name, attribute)
      object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/,"_").sub(/_$/,"") + "_" + attribute.to_s
    end
    
    def self.included(base)
      ActionView::Helpers::FormBuilder.instance_eval do
        include FormBuilderMethods
      end
    end
    
    module FormBuilderMethods
      
      def date_picker(attribute, options = {}, html_options = {})
        html_options[:id]||= DatePicker::FormHelper.field_id(self.object_name, attribute)
        @template.date_picker_tag("#{self.object_name}[#{attribute}]", self.object.send(attribute), options, html_options)
      end
      
      def datetime_picker(attribute, options = {}, html_options = {})
        html_options[:id]||= DatePicker::FormHelper.field_id(self.object_name, attribute)
        @template.datetime_picker_tag("#{self.object_name}[#{attribute}]", self.object.send(attribute), options, html_options)
      end
      
      def time_picker(attribute, options = {}, html_options = {})
        html_options[:id]||= DatePicker::FormHelper.field_id(self.object_name, attribute)
        @template.time_picker_tag("#{self.object_name}[#{attribute}]", self.object.send(attribute), options, html_options)
      end
      
    end
  end
end