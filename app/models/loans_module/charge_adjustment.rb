module LoansModule
	class ChargeAdjustment < ApplicationRecord
	  belongs_to :loan_charge

	  def charge_amount
	  	if amount.present?
	  		amount
	  	else
	  	  loan_charge.charge_amount * (percent/100.0)
	  	end
	  end
    def update_schedule
      loan_charge.loan.create_amortization_schedule
    end
	end
end
