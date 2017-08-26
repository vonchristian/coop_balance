module LoansModule 
	class InterestOnLoanCharge < Charge 
		def self.set_interest_on_loan_for(loan)
			interest = self.amount_type.regular.create!(name: 'Interest on Loan', amount: self.interest_charge_for(loan), debit_account: AccountingModule::Account.find_by(name: "Cash on Hand"),
        credit_account: AccountingModule::Revenue.find_by(name: "Service Fees"))
      loan.loan_charges.create!(chargeable: interest)
    end
    def self.interest_charge_for(loan)
    	first_year(loan)
    	# if (0..12).include?(loan.term)
    	#   first_year(loan)
    	# elsif (13..24).include?(loan.term)
    	# 	first_year(loan) + second_year(loan)
    	# elsif (25..36).include?(loan.term)
    	# 	first_year(loan) + second_year(loan) + third_year(loan)
    	# end 
    end	
    def self.first_year(loan)
    	first_year = loan.loan_amount * (loan.loan_product.interest_rate/100)
    end
    def self.second_year(loan)
    	AmortizationSchedule.principal_for(loan.amortization_schedules.order(created_at: :asc)[12], loan) * (loan.loan_product.interest_rate/100) 
    end
    def third_year(loan)
    	AmortizationSchedule.principal_for(loan.amortization_schedules.order(created_at: :asc)[24], loan) * (loan.loan_product.interest_rate/100)
    end
	end 
end 