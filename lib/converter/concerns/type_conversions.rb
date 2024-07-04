require 'date'
require 'time'

module TypeConversions
  STRING = lambda(&:to_s)
  INTEGER = lambda(&:to_i)
  SYMBOL = lambda(&:to_sym)
  FLOAT = lambda(&:to_f)
  BOOLEAN = ->(value) { !!value }
  DATE = ->(value) { Date.parse(value.to_s) if value }
  TIME = ->(value) { Time.parse(value.to_s) if value }
  DATE_TIME = ->(value) { DateTime.parse(value.to_s) if value }

  CONVERSION_METHODS = {
    string: STRING,
    integer: INTEGER,
    symbol: SYMBOL,
    float: FLOAT,
    boolean: BOOLEAN,
    date: DATE,
    time: TIME,
    date_time: DATE_TIME
  }.freeze
end
