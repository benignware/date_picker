module DatePicker
  module Generators
    class SimpleFormGenerator < ::Rails::Generators::Base
      
      argument :name, type: :string, default: "date_picker"
      
      source_root File.expand_path('../templates', __FILE__)
      
      def create_input
        template 'inputs/date_picker_input.erb', "app/inputs/" + self.name + "_input.rb", {name: self.name}
      end
      
    end
  end
end