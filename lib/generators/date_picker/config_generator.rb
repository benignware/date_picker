module DatePicker
  module Generators
    class ConfigGenerator < ::Rails::Generators::Base
      desc "Install DatePicker config"
      argument :style, type: :string, default: :bootstrap
      
      source_root File.expand_path('../templates', __FILE__)
      
      def create_config
        template 'config/date_picker.erb', "config/initializers/date_picker.rb", {style: self.style}
      end
      
    end
  end
end

