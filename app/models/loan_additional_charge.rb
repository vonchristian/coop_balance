class LoanAdditionalCharge < ApplicationRecord
	def self.total 
		all.sum(&:amount)
	end
end
