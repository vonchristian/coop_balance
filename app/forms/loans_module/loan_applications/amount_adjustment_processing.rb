module LoansModule
  module LoanApplications
    class AmountAdjustmentProcessing
      include ActiveModel::Model
      attr_reader :voucher_amount
      attr_accessor :loan_application_id, :voucher_amount_id, :amount, :rate, :adjustment_type, :number_of_payments

      validates :amount, :rate, :adjustment_type, :number_of_payments, :loan_application_id, :voucher_amount_id, presence: true
      def initialize(args)
        @voucher_amount = args[:voucher_amount]
      end
      def process!
        if valid?
          ActiveRecord::Base.transaction do
            create_adjustment
          end
        end
      end

      private
      def create_adjustment
        amount_adjustment = Vouchers::AmountAdjustment.create!(
          loan_application_id: loan_application_id,
          voucher_amount: voucher_amount,
          amount: amount,
          rate: rate,
          adjustment_type: adjustment_type,
          number_of_payments: number_of_payments)
      end

    end
  end
end
