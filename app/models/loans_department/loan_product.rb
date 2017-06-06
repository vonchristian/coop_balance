module LoansDepartment
  class LoanProduct < ApplicationRecord
    enum interest_recurrence: [:weekly, :monthly, :annually]
  end
end
