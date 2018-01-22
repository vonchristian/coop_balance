DateRange = Struct.new(:from_date, :to_date, keyword_init: true) do
  def range
    start_date..end_date
  end
  def start_date
    Chronic.parse(from_date.strftime('%Y-%m-%d 12:00:00')).beginning_of_day
  end
  def end_date
    Chronic.parse(to_date.strftime('%Y-%m-%d 12:59:59')).end_of_day
  end
end
