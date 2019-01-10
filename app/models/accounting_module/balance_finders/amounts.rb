module AccountingModule
  module BalanceFinders
    class Amounts < BaseBalanceFinder

      def compute
        amounts.total
      end
    end
  end
end
