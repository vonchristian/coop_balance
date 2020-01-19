module SavingsModule
  module Savings 
    class AveragedBalanceUpdater 
      attr_reader :saving, :date, :balance_averager

      def initialize(saving:, date:)
        @saving           = saving 
        @date             = date 
        @saving_product   = @saving.saving_product
        @balance_averager = @saving_product.saving_product_interest_config.balance_averager
      end 
      
      def update_averaged_balance 
        saving.update!(averaged_balance: daily_averaged_balance)
      end 

      private 

      def daily_averaged_balance
        balance_averager.new(saving: saving, date: date).daily_averaged_balance
      end 
    end 
  end 
end 