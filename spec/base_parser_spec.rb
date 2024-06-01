require 'csv'
require 'spec_helper'
require './base_parser'

RSpec.describe BaseParser do
  context 'when parsing the sample csv file' do
    let(:csv_path) { './spec/fixtures/sample.csv' }
    let(:sample_keys) do
      %i[
        id
        name
        age
        diagnosis
      ]
    end

    it 'parses csv file into a hash with breakfast information' do
      parsed_list = BaseParser.new(csv_path, 'sample').call

      expect(parsed_list[0]).to include(*sample_keys)
    end
  end
end
