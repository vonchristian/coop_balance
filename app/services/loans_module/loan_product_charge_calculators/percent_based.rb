module LoansModule
  module LoanProductChargeCalculators
    class PercentBased
      attr_reader :chargeable_amount, :charge

      def initialize(args)
        @charge = args.fetch(:charge)
        @chargeable_amount = args.fetch(:chargeable_amount)
      end

      def calculate
        charge.rate * chargeable_amount
      end
    end
  end
end
