class Charge < ApplicationRecord
	enum charge_type: [:percent_type, :amount_type]
  enum category: [:regular]
  belongs_to :account, class_name: "AccountingModule::Account"
  has_many :loan_charges, as: :chargeable, class_name: "LoansModule::LoanCharge"
  delegate :name, to: :account, prefix: true, allow_nil: true

  validates :amount, numericality: true, presence: true
  validates :name, presence: true

  validates :account_id, presence: true
  def self.total
    all.sum(&:charge_amount)
  end
  def self.depends_on_loan_amount
    all.where(depends_on_loan_amount: true)
  end
  def self.not_depends_on_loan_amount
    all.where(depends_on_loan_amount: false)
  end
  def self.includes_loan_amount(loan)
    all.select{|a| a.loan_amount_range.include?(loan.loan_amount) }
  end

  def amount_for(loan)
    if !depends_on_loan_amount?
    	if amount_type?
    		amount
    	elsif percent_type?
    		(percent/100.0) * loan.loan_amount
    	end
    elsif depends_on_loan_amount?
      find_approriate_charge_for(charge, loan)
    end
  end

  def loan_amount_range
    minimum_loan_amount..maximum_loan_amount
  end

  def find_appropriate_charge_for(charge, loan)
    if charge.loan_amount_range.include?(loan.loan_amount) && charge.percent_type?
      (charge.percent/100.0) * loan.loan_amount
    elsif charge.loan_amount_range.include?(loan.loan_amount) && charge.amount_type?
      charge.amount
    end
  end

  def interest_on_loan_charge
    where(type: "LoansModule::InterestOnLoanCharge")
  end
end
