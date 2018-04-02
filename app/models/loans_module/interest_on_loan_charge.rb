module LoansModule
	class InterestOnLoanCharge < Charge
  has_many :loan_charges, as: :chargeable, class_name: "LoansModule::LoanCharge"

    def charge_for(loan)
      loan_charges.where(loan: loan).last
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
