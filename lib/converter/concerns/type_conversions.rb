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
end
