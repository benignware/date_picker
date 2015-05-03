class Event < ActiveRecord::Base
  after_initialize :init_event
  
  def init_event
    self.date||= Date.tomorrow
    self.time||= Time.now + 1.hour
  end
  
end
