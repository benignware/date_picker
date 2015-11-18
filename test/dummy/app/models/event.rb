class Event < ActiveRecord::Base
  after_initialize :init_event
  
  def init_event
    self.date||= Date.today
    self.datetime||= (DateTime.now + 1.hour).change(min: 0, sec: 0)
    self.time||= (Time.current + 1.hour).change(min: 0, sec: 0)
  end
  
end
