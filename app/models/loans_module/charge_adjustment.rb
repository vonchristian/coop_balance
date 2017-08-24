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
	end
end