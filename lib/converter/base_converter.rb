require_relative 'concerns/type_conversions'

class BaseConverter
  include TypeConversions
  attr_reader :value, :selected_method, :methods_list

  def initialize(value, conversion_method)
    @value = value
    @selected_method = conversion_method&.to_sym
    @methods_list = build_conversion_methods
  end

  def call
    return @value if selected_method.nil?

    conversion_lambda = methods_list[selected_method]
    raise "Conversion type #{selected_method} not supported" unless conversion_lambda

    conversion_lambda.call(value)
  end

  private

  def build_conversion_methods
    default_conversions.merge!(custom_conversions)
  end

  def default_conversions
    build_proc_hash(TypeConversions)
  end

  def custom_conversions
    Dir.glob('parser_options/custom_conversions/*.rb').each_with_object({}) do |file, hash|
      mod = Module.new
      mod.module_eval(File.read(file), file)

      mapped_lambdas = build_proc_hash(mod)

      hash.merge!(mapped_lambdas)
    end
  end

  def build_proc_hash(mod)
    mod.constants.each_with_object({}) do |const, hash|
      hash[const.downcase] = mod.const_get(const)
    end
  end
end
