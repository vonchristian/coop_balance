module LoansModule
  module AmortizationDateSetters
    class SemiAnnually < BaseSetter
      def post_initialize(args); end

      def start_date
        date + 6.months
      end
    end
  end
end
