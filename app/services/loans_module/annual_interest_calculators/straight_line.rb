module LoansModule
  module AnnualInterestCalculators
    class StraightLine
      attr_reader :term, :rate, :amount

      def initialize(args={})
        @term   = args.fetch(:term)
        @rate   = args.fetch(:rate)
        @amount = args.fetch(:amount)
      end

      def calculate
        amount * rate * term
      end
    end
  end
end
