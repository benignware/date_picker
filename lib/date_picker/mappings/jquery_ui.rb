module DatePicker
  module Mappings
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