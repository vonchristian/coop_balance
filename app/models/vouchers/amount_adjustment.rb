module Vouchers
  class AmountAdjustment < ApplicationRecord
    enum adjustment_type: [:amount_based, :percentage_based, :number_of_payments_based]
    belongs_to :loan_application, class_name: "LoansModule::LoanApplication", dependent: :destroy
    belongs_to :voucher_amount, class_name: "Vouchers::VoucherAmount"

    validates :voucher_amount_id, presence: true
    
    def self.recent
      order(created_at: :desc).first
    end

    def adjusted_amount(args={})
      adjustable = args[:adjustable]
      if amount_based?
        amount_based_adjustment(adjustable)
      elsif percentage_based?
        percentage_based_adjustment(adjustable)
      elsif  number_of_payments_based?
        adjustable.amortization_schedules.order(date: :desc).take(number_of_payments).sum(:amount)
      end
    end

    private
    def amount_based_adjustment(adjustable)
      adjustable.amount.amount - amount
    end
    def percentage_based_adjustment(adjustable)
      adjustable.amount.amount * rate
    end
  end
end
