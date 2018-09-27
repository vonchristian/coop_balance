DateRange = Struct.new(:from_date, :to_date, keyword_init: true) do
  def range
    start_date..end_date
  end
  def start_date
    DateTime.parse(from_date.strftime('%Y-%m-%d 00:00:00 +08 +08:00'))
  end
  def end_date
    DateTime.parse(to_date.strftime('%Y-%m-%d 23:59:59 +08 +08:00'))
  end
end
