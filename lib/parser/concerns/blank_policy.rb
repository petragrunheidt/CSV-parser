module BlankPolicy
  def handle_blank(key, value, option)
    return if !value.nil? || option == 'ignore'
    return handle_error(key) if option == 'error'

    handle_warn(key)
  end

  private

  def handle_error(attribute)
    "Error: Blank value for '#{attribute}'"
  end

  def handle_warn(attribute)
    "Warning: Blank value for '#{attribute}'"
  end

  def handle_ignore
    nil
  end
end
