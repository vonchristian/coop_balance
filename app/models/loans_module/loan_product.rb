module LoansModule
  class LoanProduct < ApplicationRecord
    has_many :loans
    enum interest_recurrence: [:weekly, :monthly, :annually]
  end
end
