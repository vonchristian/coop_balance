module LoansModule
  class LoanProduct < ApplicationRecord
  	belongs_to :account, class_name: "AccountingModule::Account"
    has_many :loans
    has_many :loan_product_charges
    has_many :charges, through: :loan_product_charges

    delegate :name, to: :account, prefix: true

    validates :name, :interest_rate, :account_id, presence: true
    validates :name, uniqueness: true
    validates :interest_rate, numericality: true
    def create_charges_for(loan)
      self.charges.depends_on_loan_amount.includes_loan_amount(loan).each do |charge|
          loan.loan_charges.create(chargeable: charge)
      end
      self.charges.not_depends_on_loan_amount.each do |charge|
        loan.loan_charges.find_or_create_by(chargeable: charge)
      end
    end
    def self.accounts
      all.map{|a| a.account_name }
    end
  end
end
