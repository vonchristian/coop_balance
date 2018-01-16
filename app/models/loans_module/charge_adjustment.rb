module LoansModule
	class ChargeAdjustment < ApplicationRecord
	  belongs_to :loan_charge
    delegate :regular_charge_amount, to: :loan_charge
		def adjusted_charge_amount
	  	if amount.present?
	  		regular_charge_amount - amount
	  	else
	  	  regular_charge_amount * (percent / 100.0)
	  	end
	  end

		private
    def update_schedule
      loan_charge.loan.create_amortization_schedule
    end
	end
end
