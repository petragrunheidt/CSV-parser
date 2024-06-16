require_relative 'concerns/blank_policy'
require_relative 'concerns/yml_loader'

class BaseParser
  include YmlLoader
  include BlankPolicy
  attr_reader :csv, :row_config

  def initialize(file_path, row_config)
    @csv_body = File.read(file_path)
    @row_config = row_config
    @translation_hash = load_yml(File.basename(file_path, '.csv'))
  end

  def call
    CSV.parse(@csv_body, col_sep: ',', row_sep: "\n",
                         headers: true)
       .each_with_object({ data: [], errors: {} })
       .with_index do |(csv_row, result), index|
      row = translate_row(csv_row, @translation_hash)
      row_number = :"row-#{index + 1}"

      result[:data] << row[:data]
      result[:errors][row_number] = row[:errors]
    end
  end

  private

  def parsed_csv
    CSV.parse(
      File.read(@csv),
      col_sep: ',',
      row_sep: "\n",
      headers: true
    )
  end

  def translate_row(data_hash, translation_hash)
    translation_hash
      .each_with_object({ data: {}, errors: [] }) do |(key, attribute_policy), result|
      translated_key = attribute_policy['translation'].to_sym

      error = handle_blank(key, data_hash[key], attribute_policy['blank_policy'])
      result[:errors] << error unless error.nil?

      result[:data][translated_key] = data_hash[key]
    end
  end
end
