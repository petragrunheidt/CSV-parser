require_relative 'concerns/blank_policy'
require_relative 'concerns/detect_csv_options'
require_relative 'concerns/yml_loader'
require './lib/converter/base_converter'

class CsvLambda
  include BlankPolicy
  include DetectCsvOptions
  include YmlLoader
  attr_reader :csv_body, :translation_hash

  def initialize(csv, row_config)
    @csv_body = File.exist?(csv) ? File.read(csv) : csv
    @translation_hash = load_yml(row_config || File.basename(file_path, '.csv'))
  end

  def call
    build_hash_from_csv
  end

  private

  def build_hash_from_csv
    parsed_csv
      .each_with_object({ data: [], errors: {} })
      .with_index do |(csv_row, result), index|
      row = translate_row(csv_row, translation_hash)
      row_id = :"row-#{index + 1}"

      result[:data] << row[:data]
      result[:errors][row_id] = row[:errors] unless row[:errors].empty?
    end
  end

  def parsed_csv
    csv_options = detect_csv_options

    CSV.parse(csv_body, **csv_options)
  end

  def translate_row(data_hash, translation_hash)
    translation_hash
      .each_with_object({ data: {}, errors: [] }) do |(key, attribute_policy), result|
      translated_key = attribute_policy['translation'].to_sym
      processed_value = convert_row_value(data_hash[key], attribute_policy['convert'])

      error = handle_blank(key, data_hash[key], attribute_policy['blank_policy'])
      result[:errors] << error unless error.nil?

      result[:data][translated_key] = processed_value
    end
  end

  def convert_row_value(value, method)
    BaseConverter.new(value, method).call
  end
end
