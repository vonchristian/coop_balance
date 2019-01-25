module LoansModule
  module LoanProcessors
    class AddOnStraightLine
      attr_reader :loan, :loan_product

      def initialize(args)
        @loan = args.fetch(:loan)
        @loan_product = @loan.loan_product
      end

      def process!
        create_charges
        update_loan_amount
        create_amortization_schedule
        update_interests

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
        amortizer.
        new(loan_application: loan_application).create_schedule!
      end

      def create_charges
      loan_product.charge_setter.new(loan_application: loan).create_charges!
      end
      
      def update_interests
        loan_product.amortizer.new(loan_application: loan_application).update_interest_amounts!
      end
    end
  end
end
