# This is a sample lambda that will be read by the YAML file with the key 'example'.
# Please ensure your lambda function accepts exactly one argument representing the value
# of the row you intend to convert.

EXAMPLE = ->(value) { "#{value} kitty" }
