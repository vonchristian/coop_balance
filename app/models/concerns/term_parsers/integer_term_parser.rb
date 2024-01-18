module TermParsers
  class IntegerTermParser
    attr_reader :term

    def initialize(term)
      @term = term
    end

    def number_of_months
      term
    end

    def number_of_days
      0
    end
  end
end
