module LoansModule	
	class LoanCharge < ApplicationRecord
	  belongs_to :loan, class_name: "LoansModule::Loan"
	  belongs_to :charge
	  has_one :charge_adjustment, dependent: :destroy
	  def self.total 
	  	all.sum(&:charge_amount_with_adjustment)
	  end
	  
	  def charge_amount
	  	if charge.amount_type?
	  		charge.amount 
	  	elsif charge.percent_type?
	  		(charge.percent/100.0) * loan.loan_amount
	  	end 
	  end 
	  def balance 
	  	if charge_adjustment.present?
	  	  charge_amount - charge_adjustment.charge_amount
	  	else
	  		0
	  	end
	  end

	  def charge_amount_with_adjustment
	  	if charge_adjustment.present?
	  	  charge_adjustment.charge_amount 
	    else
	    	charge_amount
	    end
	  end
	  			
	end
end