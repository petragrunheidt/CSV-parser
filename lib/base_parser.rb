require 'yaml'

class BaseParser
  attr_reader :csv, :row_config

  TRANSLATION_PATH = './lib/row_config'.freeze

  def initialize(file_path, row_config)
    @csv_file_name = File.basename(file_path, '.csv')
    @csv_body = File.read(file_path)
    @row_config = row_config
  end

  def call
    translation_hash = load_config[@csv_file_name]

    CSV.parse(@csv_body, col_sep: ',', row_sep: "\n",
                         headers: true).each_with_object([]) do |csv_row, result|
      row = translate_row(csv_row, translation_hash)

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
      result[translated_key ] = {
        value: data_hash[key],
        error_policy: 'warn' || details['error_policy']
      }
    end
  end

  def load_config
    yml_paths = Dir.glob(File.join(TRANSLATION_PATH, '*.yml'))

    yml_paths.each_with_object({}) do |file_path, object|
      yaml_content = YAML.load_file(file_path)

      object.merge!(yaml_content)
    end
  end
end
