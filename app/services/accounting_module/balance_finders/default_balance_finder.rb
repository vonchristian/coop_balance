module AccountingModule
  module BalanceFinders
    class DefaultBalanceFinder
      attr_reader :amounts

      def initialize(amounts:)
        @amounts   ||= amounts
      end

      def compute
        amounts.total
      end
    end
  end
end
