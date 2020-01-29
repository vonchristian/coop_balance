module LoansModule
  module AmortizationDateSetters
    class Lumpsum < BaseSetter
      attr_reader :number_of_days

      def post_initialize(args)
        @number_of_days = args.fetch(:number_of_days)
      end

      def start_date
        date + number_of_days.days
      end
    end
  end
end
