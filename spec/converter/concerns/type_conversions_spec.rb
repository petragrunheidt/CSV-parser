require 'spec_helper'
require './lib/converter/base_converter'

RSpec.describe BaseConverter do
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

  it 'correctly converts to boolean' do
    converter = BaseConverter.new('yes', 'boolean')
    expect(converter.call).to eq(true)

    converter = BaseConverter.new(nil, 'boolean')
    expect(converter.call).to eq(false)

    converter = BaseConverter.new(false, 'boolean')
    expect(converter.call).to eq(false)

    converter = BaseConverter.new(0, 'boolean')
    expect(converter.call).to eq(true)
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
