module DatePicker
  module Mappings
    def self.pickadate
      {
        # Escape sequence
        _: '!*', 
        # Year with century
        Y: 'yyyy',
        # Year without a century (00..99)
        y: 'yy',
        # Day of month, blank-padded (1..31)
        e: 'd',
        # Day of the month (01..31)
        d: 'dd',
        # Day of the year (001..366)
        j: '',
        # The abbreviated weekday name (“Sun”)
        a: 'ddd',
        # The full weekday name (“Sunday”)
        A: 'dddd',
        # Month of the year (01..12)
        m: 'mm',
        # The full month name (“January”)
        B: 'mmmm',
        # The abbreviated month name (“Jan”)
        b: 'mmm',
        # Hour of the day, 24-hour clock (00..23)
        H: 'HH',
        # Hour of the day, 12-hour clock (01..12)
        I: 'hh',
        # Minute of the hour (00..59)
        M: 'i',
        # Second of the minute (00..60)
        S: '',
        # Meridian indicator (“AM” or “PM”)
        p: 'A',
        # Week number of the current year, starting with the first Sunday as the first day of the first week (00..53)
        U: '',
        # Week number of the current year, starting with the first Monday as the first day of the first week (00..53)
        W: '',
        # Day of the week (Sunday is 0, 0..6)
        w: '',
        # Time zone as hour and minute offset from UTC (e.g. +0900)
        z: ''
      }
    end
  end
end