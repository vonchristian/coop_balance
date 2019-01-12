module LoansModule
  module AmortizationDateSetters
    class Daily < BaseSetter

      def post_initialize(args)
      end

      def start_date
        date.tomorrow
      end
    end
  end
end
