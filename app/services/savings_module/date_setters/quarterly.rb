module SavingsModule
  module DateSetters
    class Quarterly
      attr_reader :saving_product, :date

      def initialize(args)
        @saving_product = args.fetch(:saving_product)
        @date           = args.fetch(:date)
      end

      def start_date
        date.beginning_of_quarter
      end

      def end_date
        date.end_of_quarter
      end
    end
  end
end
