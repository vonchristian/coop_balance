class LoanProtectionRate < ApplicationRecord
	DEFAULT_RATE = 1.35
	def self.rate_for(loan)
		rate = all.select{|a| a.age_range.include?(loan.member_age) && a.term == loan.term}.last
		if rate
			rate.rate
		else 
			DEFAULT_RATE
		end
	end
	def self.set_amount_for(loan)
		number_of_thousands = loan.loan_amount / 1_000
		number_of_thousands * self.rate_for(loan) * loan.term
	end
	def age_range
		min_age..max_age
	end
end
