module LoansModule
  module AmortizationDateSetters
    class Weekly < BaseSetter
      def post_initialize(args)
      end
      def start_date
        date.next_week
      end
    end
  end
end
