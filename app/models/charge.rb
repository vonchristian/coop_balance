class Charge < ApplicationRecord
	enum charge_type: [:percent_type, :amount_type]
  enum category: [:regular]
  belongs_to :account, class_name: "AccountingModule::Account"
  has_many :loan_charges, as: :chargeable, class_name: "LoansModule::LoanCharge"
  delegate :name, to: :account, prefix: true, allow_nil: true

  validates :amount, numericality: true, presence: true
  validates :name, :charge_type, presence: true

  validates :account_id, presence: true

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
    	compute_amount_for(loan)
    elsif depends_on_loan_amount?
      compute_amount_for_loan_amount(loan)
    end
  end

	private
	def compute_amount_for(loan)
		if amount_type?
			amount
		elsif percent_type?
			(percent/100.0) * loan.loan_amount
		end
	end

	def loan_amount_range
    minimum_loan_amount..maximum_loan_amount
  end

  def compute_amount_for_loan_amount(loan)
    if loan_amount_range.include?(loan.loan_amount) && percent_type?
      (percent/100.0) * loan.loan_amount
    elsif loan_amount_range.include?(loan.loan_amount) && amount_type?
      amount
    end
  end

end
