module LoansModule
  module InterestPredeductionCalculators
    class AmountBased
      attr_reader :amount, :interest_prededuction

      def initialize(args)
        @amount = args.fetch(:amount)
        @interest_prededuction = args.fetch(:interest_prededuction)
      end

      def calculate
        amount * interest_prededuction.rate
      end
    end
  end
end
