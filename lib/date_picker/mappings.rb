module DatePicker
  module Mappings
    def self.moment
      {
        # Escape sequence
        _: '[*]', 
        # Year with century
        Y: 'YYYY',
        # Year without a century (00..99)
        y: 'YY',
        # Day of month, blank-padded (1..31)
        e: 'D',
        # Day of the month (01..31)
        d: 'DD',
        # Day of the year (001..366)
        j: 'DDD',
        # The abbreviated weekday name (“Sun”)
        a: 'ddd',
        # The full weekday name (“Sunday”)
        A: 'dddd',
        # Month of the year (01..12)
        m: 'MM',
        # The full month name (“January”)
        B: 'MMMM',
        # The abbreviated month name (“Jan”)
        b: 'MMM',
        # Hour of the day, 24-hour clock (00..23)
        H: 'HH',
        # Hour of the day, 12-hour clock (01..12)
        I: 'hh',
        # Minute of the hour (00..59)
        M: 'mm',
        # Second of the minute (00..60)
        S: 'ss',
        # Meridian indicator (“AM” or “PM”)
        p: 'A',
        # Week number of the current year, starting with the first Sunday as the first day of the first week (00..53)
        U: 'ww',
        # Week number of the current year, starting with the first Monday as the first day of the first week (00..53)
        W: 'WW',
        # Day of the week (Sunday is 0, 0..6)
        w: 'd',
        # Time zone as hour and minute offset from UTC (e.g. +0900)
        z: 'ZZ'
      }
    end
    def self.jquery_ui
      {
        # Escape sequence
        _: "'*'",
        # Year with century
        Y: 'yy',
        # Year without a century (00..99)
        y: 'y',
        # Day of month, blank-padded (1..31)
        e: 'd',
        # Day of the month (01..31)
        d: 'dd',
        # The abbreviated weekday name (“Sun”)
        a: 'D',
        # The full weekday name (“Sunday”)
        A: 'DD',
        # Month of the year (01..12)
        m: 'mm',
        # The full month name (“January”)
        B: 'MM',
        # The abbreviated month name (“Jan”)
        b: 'M',
        # Day of the week (Sunday is 0, 0..6)
        w: 'd',
        # Time zone as hour and minute offset from UTC (e.g. +0900)
        z: 'ZZ'
      }
    end
  end
end