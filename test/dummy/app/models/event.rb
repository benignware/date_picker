class Event < ActiveRecord::Base
  after_initialize :init_event
  
  def init_event
    #self.date||= Date.today
    #self.datetime||= DateTime.now
    #self.time||= Time.now
  end
  
end
