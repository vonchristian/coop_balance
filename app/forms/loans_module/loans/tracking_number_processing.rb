module LoansModule
  module Loans
    class TrackingNumberProcessing
      include ActiveModel::Model
      attr_accessor :tracking_number, :loan_id
      validates :tracking_number, presence: true

      def save
        ActiveRecord::Base.transaction do
          create_tracking_number
        end
      end

      private
      def create_tracking_number
        find_loan.update_attributes!(tracking_number: tracking_number)
        update_voucher_reference_number
        update_entry_reference_number
      end

      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end

      def update_voucher_reference_number
        if !find_loan.forwarded_loan?
          find_loan.loan_application.voucher.update(reference_number: tracking_number) if find_loan.loan_application.voucher.present?
        end
      end

      def update_entry_reference_number
        if !find_loan.forwarded_loan?
          find_loan.loan_application.voucher.entry.update(reference_number: tracking_number) if find_loan.loan_application.voucher.present?
        end
      end
    end
  end
end
