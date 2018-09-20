module Vouchers
  class AmountAdjustment < ApplicationRecord
    belongs_to :loan_application, class_name: "LoansModule::LoanApplication"
  end
end
