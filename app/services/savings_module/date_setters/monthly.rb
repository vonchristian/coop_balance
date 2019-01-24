module SavingsModule
  module DateSetters
    class Monthly
      attr_reader :saving_product, :date

      def initialize(args)
        @saving_product = args.fetch(:saving_product)
        @date           = args.fetch(:date)
      end

      def start_date
        date.beginning_of_month
      end

      def end_date
        date.end_of_month
      end
    end
  end
end
