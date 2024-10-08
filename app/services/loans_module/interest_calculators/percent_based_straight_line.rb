module LoansModule
  module InterestCalculators
    class PercentBasedStraightLine
      attr_reader :loan_application, :loan_product, :amortization_type

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = @loan_application.loan_product
        @amortization_type = @loan_product.amortization_type
      end

      def monthly_amortization_interest
        if amortization_type.exclude_on_first_year? && loan_application.schedule_count > 12
          loan_application.total_amortizeable_interest / (loan_application.schedule_count - loan_application.number_of_days.floor)
        else
          loan_application.total_amortizeable_interest / loan_application.schedule_count
        end
      end
    end
  end
end
