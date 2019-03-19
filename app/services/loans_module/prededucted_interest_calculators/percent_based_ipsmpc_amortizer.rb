module LoansModule
  module PredeductedInterestCalculators
    class PercentBasedIpsmpcAmortizer
      attr_reader :loan_application, :interest_prededuction

      def initialize(args)
        @loan_application      = args.fetch(:loan_application)
        @loan_product          = @loan_application.loan_product
        @interest_prededuction = @loan_product.current_interest_prededuction
      end

      def prededucted_interest
        if loan_application.term <= 12
          deductible_interest_scope
        else
          deductible_interest_scope * interest_prededuction.rate
        end
      end

      private

      def deductible_interest_scope
        if interest_prededuction.on_first_year?
          loan_application.first_year_interest
        else
          loan_application.total_interest
        end
      end
    end
  end
end
