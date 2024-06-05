require 'yaml'

module YmlLoader
  TRANSLATION_PATH = './lib/row_config'.freeze

  def load_yml(key)
    yml_paths = Dir.glob(File.join(TRANSLATION_PATH, '*.yml'))

    yml_paths.each do |file_path|
      yml_content = YAML.load_file(file_path)

      return yml_content[key] if yml_content.key?(key)
    end

    nil
  end
end
