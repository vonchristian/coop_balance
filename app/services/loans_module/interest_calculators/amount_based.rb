module LoansModule
  module InterestAmortizationCalculators
    class AmountBased
      attr_reader :loan_application, :loan_product

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = args.fetch(:loan_product)
      end

      def compute
        loan_product.current_interest_prededuction.amount
      end
    end
  end
end
