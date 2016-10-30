module DatePicker
  module Mappings
    def self.flatpickr
      {
        # Escape sequence
        __: '\\\\\\\\*', 
        # Year with century
        Y: 'Y',
        # Year without a century (00..99)
        y: 'y',
        # Day of month, blank-padded (1..31)
        e: 'j',
        # Day of the month (01..31)
        d: 'd',
        # Day of the year (001..366)
        j: 'DDD',
        # The abbreviated weekday name (“Sun”)
        a: 'D',
        # The full weekday name (“Sunday”)
        A: 'l',
        # Month of the year (01..12)
        m: 'm',
        # Month of the year no-padded (1..12)
        '-m': 'n',
        # The full month name (“January”)
        B: 'F',
        # The abbreviated month name (“Jan”)
        b: 'M',
        # Hour of the day, 24-hour clock (00..23)
        H: 'H',
        # Hour of the day, 12-hour clock (01..12)
        I: 'h',
        # Minute of the hour (00..59)
        M: 'i',
        # Second of the minute (00..60)
        S: 'S',
        # Meridian indicator (“AM” or “PM”)
        p: 'K',
        # Week number of the current year, starting with the first Sunday as the first day of the first week (00..53)
        U: 'ww',
        # Week number of the current year, starting with the first Monday as the first day of the first week (00..53)
        W: 'WW',
        # Day of the week (Sunday is 0, 0..6)
        w: 'd',
        # Time zone as hour and minute offset from UTC (e.g. +0900)
        z: 'x'
      }
    end
  end
end