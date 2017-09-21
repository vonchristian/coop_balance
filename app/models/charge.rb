class Charge < ApplicationRecord
	enum charge_type: [:percent_type, :amount_type]
  enum category: [:regular]
  belongs_to :credit_account, class_name: "AccountingModule::Account"
  belongs_to :debit_account, class_name: "AccountingModule::Account"
  has_many :loan_charges, as: :chargeable, class_name: "LoansModule::LoanCharge"
  delegate :name, to: :credit_account, prefix: true, allow_nil: true
  
  def self.total
    all.sum(&:charge_amount)
  end
  
  def charge_amount(charge, loan)
  	if charge.amount_type?
  		charge.amount 
  	elsif charge.percent_type?
  		(charge.percent/100.0) * loan.loan_amount
  	end
  end

  def interest_on_loan_charge
    where(type: "LoansModule::InterestOnLoanCharge")
  end
  			
end
