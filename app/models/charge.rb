class Charge < ApplicationRecord
	enum charge_type: [:percent_type, :amount_type]
  belongs_to :credit_account, class_name: "AccountingModule::Account"
  belongs_to :debit_account, class_name: "AccountingModule::Account"
  def self.charge_amount(charge, loan)
  	if charge.amount_type?
  		charge.amount 
  	elsif charge.percent_type?
  		(charge.percent/100.0) * loan.loan_amount
  	end
  end
  			
end
