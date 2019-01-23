DateRange = Struct.new(:from_date, :to_date, keyword_init: true) do
  def range
    start_date..end_date
  end

  def start_date
    if from_date.is_a?(Date) || from_date.is_a?(Time) || from_date.is_a?(DateTime)
      from_date.strftime('%Y-%m-%d 00:00:00 +0800')
    else
      DateTime.parse(from_date).strftime('%Y-%m-%d 00:00:00 +0800')
    end
  end

  def end_date
    if to_date.is_a?(Date) || to_date.is_a?(Time) || to_date.is_a?(DateTime)
      to_date.strftime('%Y-%m-%d 23:59:59 +0800')
    else
      DateTime.zone.parse(to_date).strftime('%Y-%m-%d 23:59:59 +0800')
    end
  end
end
