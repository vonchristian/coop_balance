module LoansModule
  module LoanProcessors
    class PercentBasedIpsmpcAmortizer
      attr_reader :loan_application, :loan_product

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = @loan_application.loan_product
      end

      def process!
        create_amortization_schedule
        create_charges
        update_interests
        update_total_repayments
      end

      private

      def create_amortization_schedule
        loan_product.amortizer.new(loan_application: loan_application).create_schedule!
      end

      def create_charges
        LoansModule::LoanApplicationChargeSetter.new(loan_application: loan_application).create_charges!
      end

      def update_interests
        loan_product.amortizer.new(loan_application: loan_application).update_interest_amounts!
      end

      def update_total_repayments
        loan_product.amortizer.new(loan_application: loan_application).update_total_repayments!
      end
    end
  end
end
