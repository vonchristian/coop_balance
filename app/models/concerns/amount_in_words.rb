class AmountInWords
	attr_reader :amount
  def initialize(amount)
    @amount = amount
  end
	def parse!
    if amount.to_f.to_s.split(".").to_a.last.to_i.zero?
      amount.to_f.to_words.titleize + " Pesos"
    else
      amount.to_i.to_words.titleize +
      " Pesos and" +
      amount.to_f.to_words.split("and").map {|w| w }.last.titleize
    end
  end
end
