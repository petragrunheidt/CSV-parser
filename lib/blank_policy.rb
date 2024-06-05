module BlankPolicy
  def handle_blank(option)
    case option
    when 'error'
      handle_error
    when 'warn'
      handle_warn
    else
      handle_default
    end
  end

  private

  def handle_error
    puts 'Handling error'
  end

  def handle_warn
    puts 'Handling warning'
  end

  def handle_default
    puts 'Handling default case'
  end
end
