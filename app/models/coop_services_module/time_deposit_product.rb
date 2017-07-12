module CoopServicesModule
	class TimeDepositProduct < ApplicationRecord
	  enum interest_recurrence: [:weekly, :monthly, :annually]
	  
	  def self.set_product_for(time_deposit)
	    time_deposit_product = all.select{ |a| a.range.include?(time_deposit.balance) }.first
	    if time_deposit_product.present?
	      time_deposit.time_deposit_product = time_deposit_product
	      time_deposit.save
	    end
	  end

	  def range
	    minimum_amount..maximum_amount
	  end
	end
end