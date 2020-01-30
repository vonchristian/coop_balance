TimeRange = Struct.new(:from_time, :to_time, keyword_init: true) do
  def range
    start_time..end_time
  end

  def start_time
    if from_time.is_a?(Time)
      from_time
    else
      Time.zone.parse(from_time)
    end
  end

  def end_time
    if to_time.is_a?(Time)
      to_time
    else
    Time.zone.parse(to_time)
    end
  end
end
