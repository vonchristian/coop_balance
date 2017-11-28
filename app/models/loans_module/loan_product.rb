module LoansModule
  class LoanProduct < ApplicationRecord
  	belongs_to :account, class_name: "AccountingModule::Account"
    has_one :loan_product_interest
    has_many :loans
    has_many :member_borrowers, through: :loans, source: :borrower, source_type: 'Member'
    has_many :employee_borrowers, through: :loans, source: :borrower, source_type: 'User'
    has_many :organization_borrowers, through: :loans, source: :borrower, source_type: 'Organization'

    has_many :loan_product_charges
    has_many :charges, through: :loan_product_charges

    delegate :name, to: :account, prefix: true
    delegate :rate, :account, to: :loan_product_interest, prefix: true, allow_nil: true

    validates :name,:account_id, presence: true
    validates :name, uniqueness: true

    accepts_nested_attributes_for :loan_product_interest
    def borrowers
      member_borrowers + employee_borrowers + organization_borrowers
    end
    def interest_rate
      loan_product_interest_rate
    end
    def create_charges_for(loan)
      self.charges.depends_on_loan_amount.includes_loan_amount(loan).each do |charge|
          loan.loan_charges.create(chargeable: charge)
      end
      self.charges.not_depends_on_loan_amount.each do |charge|
        loan.loan_charges.find_or_create_by(chargeable: charge)
      end
      interest_on_loan_charge = Charge.create(name: "Interest on Loan", amount: (self.loan_product_interest_rate / 100) * loan.loan_amount, account_id: self.loan_product_interest_account.id)
      loan.loan_charges.find_or_create_by(chargeable: interest_on_loan_charge )
    end
    def self.accounts
      all.map{|a| a.account_name }
    end
  end
end
