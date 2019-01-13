module LoansModule
  module LoanProductChargeCalculators
    class AmountBased
      attr_reader :charge

      def initialize(args)
        @charge = args.fetch(:charge)
      end

      def calculate
        charge.amount
      end
    end
  end
end
