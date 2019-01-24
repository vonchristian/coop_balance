module LoansModule
  module LoanProcessors
    class AccruedStraightLine
      attr_reader :loan, :loan_product

      def initialize(args)
        @loan = args.fetch(:loan)
        @loan_product = @loan.loan_product
      end

      def process!
        create_charges
        update_loan_amount
        create_amortization_schedule
      end

      private
      def update_loan_amount
        loan.update_attributes(loan_amount: loan.loan_amount.amount + computed_interest)
      end

      def computed_interest
        loan.loan_amount.amount * loan_product.current_interest_config.rate
      end

      def create_amortization_schedule
        loan_product.
        amortization_scheduler.
        new(scheduleable: loan).create_schedule!
      end

      def create_charges
      loan_product.charge_setter.new(loan_application: loan).create_charges!
      end
    end
  end
end
