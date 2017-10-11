module LoansModule	
	class LoanCharge < ApplicationRecord
	  belongs_to :loan, class_name: "LoansModule::Loan"
	  belongs_to :chargeable, polymorphic: true
    has_many :amortization_schedules, as: :amortizeable
	  has_one :charge_adjustment, dependent: :destroy
	  delegate :debit_account, :credit_account, :credit_account_name, :debit_account_name,  to: :chargeable, allow_nil: true
	  delegate :name, :amount, :regular?, to: :chargeable, allow_nil: true
	  def self.total 
	  	all.sum(&:charge_amount_with_adjustment)
	  end
	  
	  def charge_amount
	  	if chargeable.percent_type?
	  		(chargeable.percent/100.0) * loan.loan_amount
	  	else 
	  		chargeable.amount 
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