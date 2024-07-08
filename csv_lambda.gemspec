Gem::Specification.new do |s|
  s.name        = 'csv_lambda'
  s.version     = '0.0.0'
  s.summary     = 'A simple and customizeable solution to importing data from csv files'
  s.description = `
  The CSV Lambda Tool is a Ruby-based utility designed to parse and translate CSV
  files according to configurations specified in YML files. It includes error handling and policies
  for dealing with blank fields, and it supports future enhancements
  for type conversions directly from the YML configuration.`
  s.authors     = ['Petra Grünheidt']
  s.email       = 'petragrunheidt@gmail.com'
  s.files       = ['lib/*']
  s.license = 'MIT'
  s.metadata['rubygems_mfa_required'] = 'true'

  s.required_ruby_version = '>= 3.3'
end
