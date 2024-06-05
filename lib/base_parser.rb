require_relative 'yml_loader'
require_relative 'blank_policy'

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
                         headers: true).each_with_object([]) do |csv_row, result|
      row = translate_row(csv_row, @translation_hash)

      identifier = row.first[1]
      next unless identifier

      result << row
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
    translation_hash.each_with_object({}) do |(key, details), result|
      translated_key = details['translation'].to_sym
      result[translated_key] = data_hash[key]

      handle_blank('warn' || details['error_policy']) if data_hash[key].nil?
    end
  end
end
