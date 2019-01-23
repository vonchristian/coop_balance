module LoansModule
  module InterestCalculators
    class AddOnStraightLine
      attr_reader :loan_application, :loan_product

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = @loan_application.loan_product
      end

      def monthly_amortization_interest
        loan_application.add_on_interest / loan_application.schedule_count
      end
    end
  end
end
