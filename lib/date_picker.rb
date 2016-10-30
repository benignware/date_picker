require 'date_picker/railtie' if defined? ::Rails::Railtie
require 'date_picker/mappings/moment'
require 'date_picker/mappings/jquery_ui'
require 'date_picker/mappings/pickadate'
require 'date_picker/mappings/flatpickr'
require 'date_picker/form_tag_helper'
require 'date_picker/form_helper'
require 'i18n'

module DatePicker
  
  class Config
    attr_accessor :style, :formats
  end

  def self.config
    @@config||= Config.new
  end

  def self.configure
    yield self.config
  end

end