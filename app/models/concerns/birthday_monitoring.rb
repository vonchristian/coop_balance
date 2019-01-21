module BirthdayMonitoring
  def birthday_on_month(month)
    where(birth_month: month)
  end
  def birthday_on_day(day)
    where(birth_day: day)
  end
  def birthday_on_year(year)
    where(birth_year: year)
  end
end
