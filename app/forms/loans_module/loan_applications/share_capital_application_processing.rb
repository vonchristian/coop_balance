module LoansModule
  module LoanApplications
    class ShareCapitalApplicationProcessing
      include ActiveModel::Model
      attr_accessor :loan_application_id

      def process!
        if valid?
          ActiveRecord::Base.transaction do
            create_share_capital_application
            create_voucher_amount
          end
        end
      end

      private
      def create_share_capital_application
      end
    end
  end
end
