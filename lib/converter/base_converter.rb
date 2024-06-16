require_relative 'concerns/type_conversions'

class BaseConverter
  include TypeConversions
  attr_reader :value, :conversion_method

  def initialize(value, conversion_method)
    @value = value
    @conversion_method = conversion_method.to_sym
  end

  def call
    conversion_lambda = CONVERSION_METHODS[@conversion_method]
    raise "Conversion type #{@conversion_method} not supported" unless conversion_lambda

    conversion_lambda.call(@value)
  end
end
