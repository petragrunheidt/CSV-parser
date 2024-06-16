require 'json'

module TypeConversions
  STRING = lambda(&:to_s)
  INTEGER = lambda(&:to_i)
  SYMBOL = lambda(&:to_sym)
  FLOAT = lambda(&:to_f)
  BOOLEAN = ->(value) { !!value }
  JSON = ->(value) { ::JSON.parse(value, symbolize_names: true) }

  CONVERSION_METHODS = {
    string: STRING,
    integer: INTEGER,
    symbol: SYMBOL,
    float: FLOAT,
    boolean: BOOLEAN,
    json: JSON
  }.freeze
end
