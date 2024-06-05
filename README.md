# CSV Parsing Tool (Under development)

## Overview

The CSV Parsing Tool is a Ruby-based utility designed to parse and translate CSV files according to configurations specified in YML files. It includes error handling and policies for dealing with blank fields, and it supports future enhancements for type conversions directly from the YML configuration.

## Features

- **YAML Configuration**: Load configurations from a YAML file to translate CSV columns.
- **Blank Field Policies**: Handle blank fields according to specified policies (e.g., warn, ignore).
- **Flexible Parsing**: Easily extendable for additional functionalities like type conversion.

## Installation

To use the CSV Parsing Tool, clone the repository and ensure you have Ruby installed on your system.

## Usage

### Basic Usage

To use the tool, initialize a `BaseParser` object with the path to your CSV file and the row configuration:

```rb
require_relative 'base_parser'

file_path = 'path/to/your/file.csv'
row_config = {
  'id' => { 'translation' => 'id', 'blank_policy' => 'warn' },
  'nome' => { 'translation' => 'name' },
  'idade' => { 'translation' => 'age' },
  'diagnostico' => { 'translation' => 'diagnosis' }
}

parser = BaseParser.new(file_path, row_config)
parsed_data = parser.call
```

## YML Configuration

The YAML configuration file specifies how to translate CSV columns and handle blank fields. Here's an example:

```yml
identificação: # row name as written in the csv file
  translation: id # transforms row header to this value 
  #under development
  blank_policy: warn #(optional) policy for handling blank values ignore/warn/error
  type: integer #(optional) calls default functions to perform type transformations
  transform: custom_function #(optional) calls custom function to transform the value
nome:
  translation: name
idade:
  translation: age
diagnostico: 
  translation: diagnosis
```
