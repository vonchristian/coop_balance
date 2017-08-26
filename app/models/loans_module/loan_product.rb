module LoansModule
  class LoanProduct < ApplicationRecord
  	belongs_to :account, class_name: "AccountingModule::Account"
    has_many :loans
    has_many :loan_product_charges
    has_many :charges, through: :loan_product_charges
    enum interest_recurrence: [:weekly, :monthly, :annually]
    delegate :name, to: :account, prefix: true, allow_nil: true

    validates :name, :interest_rate, presence: true 
    validates :interest_rate, numericality: true
  end
end