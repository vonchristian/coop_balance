module LoansModule
  module LoanApplicationProcessors
    class NumberOfPaymentsDecliningBalance
      attr_reader :loan_application

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = args.fetch(:loan_product)
        @interest_config  = @loan_product.current_interest_config
        @amortization_type  = @loan_product.amortization_type
      end
    end
  end
end
