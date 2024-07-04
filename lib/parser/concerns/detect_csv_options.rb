module DetectCsvOptions
  def detect_csv_options
    sample = csv_body.lines[0..10].join
    col_sep = detect_col_sep(sample)
    row_sep = detect_row_sep(csv_body)
    headers = true

    {
      col_sep:,
      row_sep:,
      headers:
    }
  end

  private

  def detect_col_sep(sample)
    potential_separators = [',', ';', "\t"]
    counts = potential_separators.to_h { |sep| [sep, sample.count(sep)] }
    counts.max_by { |_, count| count }.first
  end

  def detect_row_sep(csv_body)
    return "\r\n" if csv_body.include?("\r\n")

    return "\n" if csv_body.include?("\n")

    raise 'could not detect row separator for the csv file'
  end
end
