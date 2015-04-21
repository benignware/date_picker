require 'rails'
require 'i18n'

module DatePicker
  class Railtie < ::Rails::Railtie
    
    railtie_name :date_picker
    
    # requires all dependencies
    Gem.loaded_specs['date_picker'].dependencies.each do |d|
     require d.name
    end
    
    # application configuration initializer
    config.date_picker = ActiveSupport::OrderedOptions.new # enable namespaced configuration in Rails environments
  
    initializer "date_picker.configure" do |app|
      DatePicker.configure do |config|
        # copy parameters from application configuration
        config.style = app.config.date_picker[:style]
        config.formats = app.config.date_picker[:formats]
      end
    end
   
    initializer "date_picker.view" do
      ActiveSupport.on_load :action_view do
        include DatePicker::FormTagHelper
        include DatePicker::FormHelper
      end
    end
    
  end
end