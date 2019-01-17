DateRange = Struct.new(:from_date, :to_date, keyword_init: true) do
  def range
    start_date..end_date
  end

  def start_date
    if from_date.is_a?(Date) || from_date.is_a?(Time) || from_date.is_a?(DateTime)
      from_date.yesterday.end_of_day.strftime('%Y-%m-%d 00:00:00')
    else
      DateTime.parse(from_date.strftime('%Y-%m-%d 00:00:00'))
    end
  end

  def end_date
    if to_date.is_a?(Date) || to_date.is_a?(Time) || from_date.is_a?(DateTime)
      to_date.strftime('%Y-%m-%d 23:59:59')
    else
      DateTime.parse(to_date.strftime('%Y-%m-%d 23:59:59'))
    end
  end
end
