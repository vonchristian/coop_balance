module LoansModule
  module InterestPredeductionCalculators
    class PercentBased
      attr_reader :interest_prededuction, :amount

      def initialize(args)
        @interest_prededuction = args.fetch(:interest_prededuction)
        @amount                = args.fetch(:amount)
      end

      def calculate
        amount * interest_prededuction.rate 
      end
    end
  end
end
