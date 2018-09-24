module Vouchers
  class AmountAdjustment < ApplicationRecord
    belongs_to :loan_application, class_name: "LoansModule::LoanApplication"
    has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy
  end
end
