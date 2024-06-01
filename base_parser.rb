require 'yaml'

class BaseParser
  attr_reader :csv, :row_config
  TRANSLATION_PATH = './row_config'

  def initialize(file_path, row_config)
    @csv_file_name = File.basename(file_path, '.csv')
    @csv_body = File.read(file_path)
    @row_config = row_config
  end

  def call
    row_config = load_config[@csv_file_name]

    CSV.parse(@csv_body, col_sep: ',', row_sep: "\n", headers: true).each_with_object([]) do |csv_row, result|
      translation_object = row_config['translations']
      row = csv_row.to_h.slice(*translation_object.keys).transform_keys { |k| translation_object[k].to_sym }

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

  def load_config
    yml_paths = Dir.glob(File.join(TRANSLATION_PATH, '*.yml'))

    yml_paths.each_with_object({}) do |file_path, object|
      yaml_content = YAML.load_file(file_path)

      object.merge!(yaml_content)
    end
  end
end
