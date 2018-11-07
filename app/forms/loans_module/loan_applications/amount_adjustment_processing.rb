module LoansModule
  module LoanApplications
    class AmountAdjustmentProcessing
      include ActiveModel::Model
      attr_accessor :loan_application_id, :voucher_amount_id, :amount, :rate, :adjustment_type, :number_of_payments

      validates :loan_application_id, :voucher_amount_id, presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_adjustment
        end
      end

      private
      def create_adjustment
        amount_adjustment = Vouchers::AmountAdjustment.create!(
          loan_application_id: loan_application_id,
          voucher_amount_id: voucher_amount_id,
          amount: amount,
          rate: rate,
          adjustment_type: adjustment_type,
          number_of_payments: number_of_payments)
        find_voucher_amount.update_attributes!(amount_adjustment: amount_adjustment)
      end
      def find_voucher_amount
        Vouchers::VoucherAmount.find(voucher_amount_id)
      end
    end
  end
end
