require 'spec_helper'
require './lib/converter/base_converter'

RSpec.describe BaseConverter do
  context '#TypeConversions' do
    it 'correctly converts to string' do
      converter = BaseConverter.new(123, 'string')
      expect(converter.call).to eq('123')
    end

    it 'correctly converts to integer' do
      converter = BaseConverter.new('123', 'integer')
      expect(converter.call).to eq(123)
    end

    it 'correctly converts to symbol' do
      converter = BaseConverter.new('hello', 'symbol')
      expect(converter.call).to eq(:hello)
    end

    it 'correctly converts to float' do
      converter = BaseConverter.new('123.45', 'float')
      expect(converter.call).to eq(123.45)
    end

    it 'correctly converts to json' do
      json_string = '{"data":{"someKey":"someValue","anotherKey":"value"}}'
      converter = BaseConverter.new(json_string, 'json')
      expect(converter.call).to eq({ data: { someKey: 'someValue', anotherKey: 'value' } })
    end

    boolean_test_cases = [
      { input: 'yes', expected_output: true },
      { input: nil, expected_output: false },
      { input: false, expected_output: false },
      { input: 0, expected_output: true }
    ]
    boolean_test_cases.each do |test_case|
      it "correctly converts #{test_case[:input]} to boolean" do
        converter = BaseConverter.new(test_case[:input], 'boolean')
        expect(converter.call).to eq(test_case[:expected_output])
      end
    end

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
