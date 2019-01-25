module LoansModule
  module LoanProcessors
    class AccruedStraightLine
      attr_reader :loan_application, :loan_product

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = @loan.loan_product
      end

      def process!
        create_charges
        update_loan_amount
        create_amortization_schedule
      end

      private
      def update_loan_amount
        loan_application.update_attributes(loan_amount: loan.loan_amount.amount + computed_interest)
      end

      def computed_interest
        loan_product.current_interest_config.compute_interest(loan.loan_amount.amount)
      end

      def create_amortization_schedule
        loan_product.
        amortizer.
        new(loan_application: loan_application).create_schedule!
      end

      def create_charges
      loan_product.charge_setter.new(loan_application: loan).create_charges!
      end
    end
  end
end
