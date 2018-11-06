module Vouchers
  class AmountAdjustment < ApplicationRecord
    belongs_to :loan_application, class_name: "LoansModule::LoanApplication"
    has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy
    def adjusted_amount
      if number_of_payments && number_of_payments > 0
        loan_application.amortization_schedules.order(date: :asc).first(number_of_payments).sum(&:interest)
      elsif percent
        amount * (percent / 100.0)
      else
        amount
      end
    end
  end
end
