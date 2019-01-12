module LoansModule
  module AmortizationDateSetters
    class Quarterly < BaseSetter

      def post_initialize(args)
      end

      def start_date
        date.next_quarter
      end
    end
  end
end
