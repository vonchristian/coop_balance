class ProperDateFinder
  attr_reader :date, :operating_days

  def initialize(date, operating_days)
    @date = date
    @operating_days = operating_days
  end
  def proper_date
    return date if (date.strftime("%A")).in?(operating_days)
    if (date.next_day.strftime("%A")).in?(operating_days)
      date.next_day
    elsif (date.next_day.next_day.strftime("%A")).in?(operating_days)
      date.next_day.next_day
    end
  end
end
