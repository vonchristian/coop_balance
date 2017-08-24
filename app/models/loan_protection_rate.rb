class LoanProtectionRate < ApplicationRecord
	def self.rate_for(loan)
		rate = all.select{|a| a.age_range.include?(loan.member_age) && a.term == loan.term}.last
		if rate
			rate.percent
		end
	end
end
