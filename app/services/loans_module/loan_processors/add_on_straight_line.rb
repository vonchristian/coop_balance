module LoansModule
  module LoanProcessors
    class AddOnStraightLine
      attr_reader :loan_application, :loan_product

      def initialize(args)
        @loan_application = args.fetch(:loan)
        @loan_product = @loan_application.loan_product
      end

      def process!
        create_charges
        update_loan_amount
        create_amortization_schedule
        update_interests

      end

      private
      def update_loan_amount
        LoansModule::LoanApplicationAmountUpdater.new(loan_application: loan_application).update_amount
      end

      def create_amortization_schedule
        loan_product.
        amortizer.
        new(loan_application: loan_application).create_schedule!
      end

      def create_charges
      loan_product.charge_setter.new(loan_application: loan_application).create_charges!
      end

      def update_interests
        loan_product.amortizer.new(loan_application: loan_application).update_interest_amounts!
      end
    end
  end
end
