module TermParsers
  class FloatTermParser
    attr_reader :term
    NUMBER_OF_DAYS_IN_MONTHS = 30

    def initialize(term)
      @term = term
    end

    def number_of_months
      term.to_s.split(".").first.to_i
    end

    def number_of_days
      NUMBER_OF_DAYS_IN_MONTHS * days_multiplier
    end
    
    def days_multiplier
      number = (term.to_s.split(".")).last.to_s
      if number.to_s.size == 1
        multiplier = ((number + "0").to_f / 100.0)
      else
        multiplier = (number.to_i / 100.0)
      end
    end
  end
end
