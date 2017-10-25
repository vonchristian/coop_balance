module CoopServicesModule
	class TimeDepositProduct < ApplicationRecord
	  enum time_deposit_product_type: [:for_member, :for_non_member]
    has_one :break_contract_fee
	  
    def self.set_product_for(time_deposit)
      if time_deposit.member?
       set_time_deposit_product_for_member(time_deposit)
      elsif time_deposit.non_member?
        set_time_deposit_product_for_non_member(time_deposit)
      end
    end

    def amount_range
      minimum_amount..maximum_amount
    end

    private
    def self.set_time_deposit_product_for_member(time_deposit) 
	    time_deposit_product = for_member.select{ |a| a.amount_range.include?(time_deposit.amount_deposited) }.first
	    if time_deposit_product.present?
	      time_deposit.time_deposit_product = time_deposit_product
	      time_deposit.save
	    end
	  end
     def self.set_time_deposit_product_for_non_member(time_deposit) 
      time_deposit_product = for_non_member.select{ |a| a.amount_range.include?(time_deposit.amount_deposited) }.first
      if time_deposit_product.present?
        time_deposit.time_deposit_product = time_deposit_product
        time_deposit.save
      end
    end
	end
end