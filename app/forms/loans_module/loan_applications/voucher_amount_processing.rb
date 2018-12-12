module LoansModule
  module LoanApplications
    class VoucherAmountProcessing
      include ActiveModel::Model
      attr_accessor :amount, :account_id, :description, :loan_application_id
      validates :amount, :account_id, presence: true

      def process!
        if valid?
          ActiveRecord::Base.transaction do
            create_voucher_amount
            update_amortization_schedule
          end
        end
      end

      private
      def create_voucher_amount
        Vouchers::VoucherAmount.credit.create(
          commercial_document: find_loan_application,
          loan_application: find_loan_application,
          amount:              amount,
          account_id:          account_id,
          description:         description
        )
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
