module LoansModule
  module Loans
    class TrackingNumberProcessing
      include ActiveModel::Model
      attr_accessor :tracking_number, :loan_id

      def save
        ActiveRecord::Base.transaction do
          create_tracking_number
        end
      end

      private
      def create_tracking_number
        find_loan.update_attributes!(tracking_number: tracking_number)
      end
      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end
    end
  end
end
