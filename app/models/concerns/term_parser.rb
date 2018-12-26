class TermParser
  #parse Integer and Float terms
  attr_reader :term
  def initialize(args)
    @term   = args[:term]
  end

  def add_months
    parser.new(term).number_of_months.months
  end
  def add_days
    parser.new(term).number_of_days.days
  end
  def parser
    if term.is_a?(Integer)
      TermParsers::IntegerTermParser
    elsif term.is_a?(Float)
      TermParsers::FloatTermParser
    end
  end
end
