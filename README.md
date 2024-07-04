# CSV Parsing Tool (Under development)

## Overview

The CSV Parsing Tool is a Ruby-based utility designed to parse and translate CSV files according to configurations specified in YML files. It includes error handling and policies for dealing with blank fields, and it supports future enhancements for type conversions directly from the YML configuration.

## Features

- **YAML Configuration**: Load configurations from a YAML file to translate CSV columns.
- **Blank Field Policies**: Handle blank fields according to specified policies (e.g., warn, ignore).
- **Basic Type Conversions**: Enable straightforward conversion of data types, ensuring seamless handling of CSV column data.
- **Automatic CSV Detection**: Automatically detect CSV file characteristics, such as delimiters, ensuring compatibility with various file formats and configurations.

## Installation

To use the CSV Parsing Tool, clone the repository and ensure you have Ruby installed on your system.

## Usage

### Basic Usage

To use the tool, initialize a `BaseParser` object with the path to your CSV file or a File object and the identifier to your yml's row configuration:

```rb
file_path = 'path/to/your/file.csv'
# or use => csv = File.read('path/to/your/file.csv')

row_config = 'exemplo' # key to yml file

parser = BaseParser.new(file_path, row_config)
parsed_data = parser.call
```

## YML Configuration

The YAML configuration file specifies how to translate CSV columns and handle blank fields. Here's an example:

```yml
exemplo:
  id: # row name as written in the csv file
    translation: id # transforms row header to this value 
    blank_policy: error #(optional) policy for handling blank values ignore/warn/error
    convert: integer #(optional) calls default functions to perform type transformations
  nome:
    translation: name
  idade:
    translation: age
    blank_policy: warn
    convert: integer
  diagnostico: 
    translation: diagnosis
```

## Example output

```rb
{
  data: [
    { id: nil, name: "John Doe", age: 45, diagnosis: "Hypertension" },
    { id: "102", name: "Jane Smith", age: 0, diagnosis: "Type 2 Diabetes" },
    { id: "103", name: "Michael Johnson", age: 60, diagnosis: nil },
    { id: "104", name: "Emily Brown", age: 28, diagnosis: "Seasonal Allergies" },
    { id: "105", name: "David Martinez", age: 50, diagnosis: "Chronic Obstructive Pulmonary Disease" },
    { id: "106", name: "Sarah Wilson", age: 38, diagnosis: "Asthma" },
    { id: "107", name: "Robert Taylor", age: 55, diagnosis: "Coronary Heart Disease" },
    { id: "108", name: "Emma Anderson", age: 42, diagnosis: nil }
  ],
  errors: {
    :"row-1" => ["Error: Blank value for 'id'"],
    :"row-2" => ["Warning: Blank value for 'idade'"],
    :"row-8" => ["Warning: Blank value for 'diagnostico'"]
  }
}
```
