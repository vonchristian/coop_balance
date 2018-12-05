module LoansModule
  module LoanApplications
    class AmountAdjustmentProcessing
      include ActiveModel::Model
      attr_accessor :loan_application_id, :voucher_amount_id, :amount, :rate, :adjustment_type, :number_of_payments

      validates :amount, :rate, :adjustment_type, :number_of_payments, :loan_application_id, :voucher_amount_id, presence: true

      def process!
        if valid?
          ActiveRecord::Base.transaction do
            create_adjustment
            update_amortization_schedule
          end
        end
      end

      private
      def create_adjustment
        amount_adjustment = Vouchers::AmountAdjustment.create!(
          loan_application_id: loan_application_id,
          voucher_amount_id:   voucher_amount_id,
          amount:              amount,
          rate:                rate,
          adjustment_type:     adjustment_type,
          number_of_payments:  number_of_payments)
      end
      def update_amortization_schedule
        if find_loan_application.amortization_schedules.present?
          find_loan_application.amortization_schedules.destroy_all
        end
        LoansModule::AmortizationSchedule.create_amort_schedule_for(find_loan_application)
      end
      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end
    end
  end
end
