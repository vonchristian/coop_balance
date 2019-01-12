module LoansModule
  module AmortizationDateSetters
    class Monthly < BaseSetter

      def post_initialize(args)
      end

      def start_date
        date.next_month
      end

      def next_date
        start_date
      end
      
    end
  end
end
