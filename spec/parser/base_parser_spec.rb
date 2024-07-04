require 'csv'
require_relative '../spec_helper'
require './lib/parser/base_parser'

RSpec.describe BaseParser do
  let(:csv_path) { './spec/fixtures/sample.csv' }
  let(:sample_keys) do
    %i[
      id
      name
      age
      diagnosis
    ]
  end

  context 'when parsing the sample csv file' do
    it 'parses csv file into a hash with breakfast information' do
      parsed_list = BaseParser.new(csv_path, 'sample').call

      expect(parsed_list[:data][0]).to include(*sample_keys)
    end
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

  context 'detect_csv_options' do
    context 'row_sep' do
      it 'correctly detects "\n" separator' do
        csv = "id,nome,idade,diagnostico\n101,John Doe,45,tension\n102,Jane Smith,,Diabetes\n"

        parsed_list = BaseParser.new(csv, 'sample').call

        expect(parsed_list[:data][0]).to include(*sample_keys)
      end

      it 'correctly detects "\r\n" separator' do
        csv = "id,nome,idade,diagnostico\r\n101,John Doe,45,tension\r\n102,Jane Smith,,Diabetes\r\n"

        parsed_list = BaseParser.new(csv, 'sample').call

        expect(parsed_list[:data][0]).to include(*sample_keys)
      end
    end

    context 'col_sep' do
      it 'correctly detects comma separator' do
        csv = <<~CSV
          id,nome,idade,diagnostico
          101,John Doe,45,Hypertension
          102,Jane Smith,,Type 2 Diabetes
        CSV

        parsed_list = BaseParser.new(csv, 'sample').call

        expect(parsed_list[:data][0]).to include(*sample_keys)
      end

      it 'correctly detects semicolon separator' do
        csv = <<~CSV
          id;nome;idade;diagnostico
          101;John Doe;45;Hypertension
          102;Jane Smith;;Type 2 Diabetes
        CSV

        parsed_list = BaseParser.new(csv, 'sample').call

        expect(parsed_list[:data][0]).to include(*sample_keys)
      end

      it 'correctly detects tab separator' do
        csv = <<~CSV
          id\tnome\tidade\tdiagnostico
          101\tJohn Doe\t45\tHypertension
          102\tJane Smith\tType 2 Diabetes
        CSV

        parsed_list = BaseParser.new(csv, 'sample').call

        expect(parsed_list[:data][0]).to include(*sample_keys)
      end
    end
  end

  context 'converter' do
    it 'successfully reads and applies basic conversion from yml convert key' do
      parsed_list = BaseParser.new(csv_path, 'sample').call
      sample_age_value = parsed_list[:data][0][:age]

      expect(sample_age_value.class).to eq(Integer)
    end
  end
end
