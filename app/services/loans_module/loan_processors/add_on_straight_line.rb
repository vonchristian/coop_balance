module LoansModule
  module LoanProcessors
    class AddOnStraightLine
      attr_reader :loan, :loan_product

      def initialize(args)
        @loan = args.fetch(:loan)
        @loan_product = @loan.loan_product
      end
      def process!
        create_amortization_schedule
        create_charges
      end

      private
      def create_amortization_schedule
        loan_product.amortization_scheduler.new(scheduleable: loan).create_schedule!
      end
      def create_charges
        LoansModule::ChargeSetters::AddOnLoanApplication.new(loan: loan).create_charges!
      end
    end
  end
end
