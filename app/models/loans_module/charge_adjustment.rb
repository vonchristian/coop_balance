module LoansModule
	class ChargeAdjustment < ApplicationRecord
	  belongs_to :loan_charge

		delegate :regular_charge_amount, to: :loan_charge

		def adjusted_charge_amount
	  	if amount.present?
	  		regular_charge_amount - amount
	  	elsif number_of_payments.present?
        loan_charge.loan.amortization_schedules.order(date: :asc).first(number_of_payments).sum(&:interest)
	  	else
	  	  regular_charge_amount * (percent / 100.0)
	  	end
	  end
		def amortizeable_amount
			if amortize_balance?
				adjusted_charge_amount
			else
				0
			end
		end
	end
end
