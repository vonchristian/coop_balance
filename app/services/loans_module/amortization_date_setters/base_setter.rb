module LoansModule
  module AmortizationDateSetters
    class BaseSetter
      attr_reader :date

      def initialize(args)
        @date = args.fetch(:date)
        post_initialize(args)
      end

      def next_date
        start_date
      end
    end
  end
end
