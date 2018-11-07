module Vouchers
  class AmountAdjustment < ApplicationRecord
    enum adjustment_type: [:amount_based, :percentage_based, :number_of_payments_based]
    belongs_to :loan_application, class_name: "LoansModule::LoanApplication"
    belongs_to :voucher_amount, class_name: "Vouchers::VoucherAmount"

    def self.recent
      order(created_at: :desc).first
    end

    def adjusted_amount(args={})
      adjustable = args[:adjustable]
      if amount_based?
        adjustable.amount - amount
      elsif percentage_based?
        adjustable.amount * rate
      elsif  number_of_payments_based?
      adjustable.amortization_schedules.order(date: :desc).take(number_of_payments).sum(:amount)
      end
    end
  end
end
