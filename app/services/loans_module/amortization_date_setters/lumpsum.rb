module LoansModule
  module AmortizationDateSetters
    class Lumpsum < BaseSetter
      attr_reader :term

      def post_initialize(args)
        @term = args.fetch(:term)
      end

      def start_date
        date + term.floor.months
      end
    end
  end
end
