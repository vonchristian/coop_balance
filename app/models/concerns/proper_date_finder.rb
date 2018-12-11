class ProperDateFinder
  attr_reader :date, :operating_days

  def initialize(args)
    @date           = args[:date]
    @operating_days = args[:operating_days] || ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
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
