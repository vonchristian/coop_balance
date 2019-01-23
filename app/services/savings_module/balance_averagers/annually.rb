module SavingsModule
  module BalanceAveragers
    class Annually
      attr_reader :saving, :to_date
      def initialize(args)
        @saving = args.fetch(:saving)
        @to_date = args.fetch(:to_date)
        @from_date = @to_date.beginning_of_year
      end
      def averaged_balance
      end
    end
  end
end
def set_balance_status
  if paid_up_balance >= share_capital_product.minimum_balance
    self.has_minimum_balance = true
  else
    self.has_minimum_balance = false
  end
  self.save
end
