DatePicker.configure do |config|
  config.style = :pickadate
  config.formats = {
    date: :default,
    datetime: :default,
    time: :only_time
  }
end