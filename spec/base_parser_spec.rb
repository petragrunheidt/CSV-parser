require 'csv'
require 'spec_helper'
require './lib/base_parser'

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

      expect(parsed_list[:data][0]).to include(*sample_keys)
    end

    context 'blank_policy' do
      context 'error' do
        it 'correctly saves error of missing attribute in the second row' do
          parsed_list = BaseParser.new(csv_path, 'sample').call

          expect(parsed_list[:errors][:'row-1']).to include('Error: Blank value for \'id\'')
        end
      end

      context 'warn' do
        it 'correctly saves warning of missing attribute in the second row' do
          parsed_list = BaseParser.new(csv_path, 'sample').call

          expect(parsed_list[:errors][:'row-2']).to include('Warning: Blank value for \'idade\'')
        end
      end

      context 'ignore' do
        it 'does not save warning if policy is set to ignore' do
          parsed_list = BaseParser.new(csv_path, 'sample').call

          expect(parsed_list[:errors][:'row-3']).to be_empty
        end
      end
    end
  end
end
