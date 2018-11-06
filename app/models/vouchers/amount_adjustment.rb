module Vouchers
  class AmountAdjustment < ApplicationRecord
    enum adjustment_type: [:amount_based, :percentage_based, :number_of_payments]
    belongs_to :loan_application, class_name: "LoansModule::LoanApplication"
    has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy

    def adjusted_amount(args={})
      if args[:voucher_amount].present?
        adjusted_amount_for_voucher_amount(args[:voucher_amount])
      elsif args[:loan_application]
        adjusted_amount_for_loan_application(args[:loan_application])
      end
    end

    private
    def adjusted_amount_for_voucher_amount(voucher_amount)
      if amount_based?
        voucher_amount.amount - amount
      elsif percentage_based?
        voucher_amount.amount * rate
      end
    end

    def adjusted_amount_for_loan_application(loan_application)
      loan_application.amortization_schedules.order(date: :desc).take(number_of_payments).sum(:amount)
    end
  end
end
