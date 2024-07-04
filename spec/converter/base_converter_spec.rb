require 'spec_helper'
require './lib/converter/base_converter'

RSpec.describe BaseConverter do
  context '#TypeConversions' do
    context 'STRING' do
      it 'correctly converts to string' do
        converter = BaseConverter.new(123, 'string')
        result = converter.call
        expect(result).to eq('123')
        expect(result).to be_a(String)
      end
    end

    context 'INTEGER' do
      it 'correctly converts to integer' do
        converter = BaseConverter.new('123', 'integer')
        result = converter.call
        expect(result).to eq(123)
        expect(result).to be_a(Integer)
      end
    end

    context 'SYMBOL' do
      it 'correctly converts to symbol' do
        converter = BaseConverter.new('hello', 'symbol')
        result = converter.call
        expect(result).to eq(:hello)
        expect(result).to be_a(Symbol)
      end
    end

    context 'FLOAT' do
      it 'correctly converts to float' do
        converter = BaseConverter.new('123.45', 'float')
        result = converter.call
        expect(result).to eq(123.45)
        expect(result).to be_a(Float)
      end
    end

    context 'BOOLEAN' do
      boolean_test_cases = [
        { input: 'yes', expected_output: true },
        { input: nil, expected_output: false },
        { input: false, expected_output: false },
        { input: 0, expected_output: true }
      ]
      boolean_test_cases.each do |test_case|
        it "correctly converts #{test_case[:input]} to boolean" do
          converter = BaseConverter.new(test_case[:input], 'boolean')
          result = converter.call
          expect(result).to eq(test_case[:expected_output])
        end
      end
    end

    context 'DATE' do
      it 'correctly converts to date' do
        converter = BaseConverter.new('2021-12-31', 'date')
        result = converter.call
        expect(result).to eq(Date.parse('2021-12-31'))
        expect(result).to be_a(Date)
      end
    end

    context 'TIME' do
      it 'correctly converts to time' do
        converter = BaseConverter.new('2021-12-31 23:59:59', 'time')
        result = converter.call
        expect(result).to eq(Time.parse('2021-12-31 23:59:59'))
        expect(result).to be_a(Time)
      end
    end

    context 'DATE_TIME' do
      it 'correctly converts to date_time' do
        converter = BaseConverter.new('2021-12-31T23:59:59', 'date_time')
        result = converter.call
        expect(result).to eq(DateTime.parse('2021-12-31T23:59:59'))
        expect(result).to be_a(DateTime)
      end
    end

    context 'error handling' do
      it 'returns original value if conversion_kind is nil' do
        converter = BaseConverter.new('value', nil)

        expect(converter.call).to eq('value')
      end

      it 'raises error if conversion kind is not supported' do
        converter = BaseConverter.new('hi', 'unsupported_conversion_kind')
        error_message = 'Conversion type unsupported_conversion_kind not supported'

        expect { converter.call }.to raise_error do |error|
          expect(error).to be_a(RuntimeError)
          expect(error.message).to eq(error_message)
        end
      end
    end
  end
end
