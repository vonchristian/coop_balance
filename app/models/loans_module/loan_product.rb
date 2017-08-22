module LoansModule
  class LoanProduct < ApplicationRecord
    has_many :loans
    has_many :loan_product_charges
    has_many :charges, through: :loan_product_charges
    enum interest_recurrence: [:weekly, :monthly, :annually]
  end
end