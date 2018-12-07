class TermParser
  attr_reader :term
  def initialize(term)
    @term = term
  end
  def number_of_months
    return term if term.is_a?(Integer)
    term.to_s.split(".").first.to_i
  end
  def number_of_days
    return 0 if term.is_a?(Integer)
    ((term.to_s.split(".").last.to_f) / 30 * 100).floor
  end
  def add_months
    number_of_months.months
  end
  def add_days
    number_of_days.days
  end
end
