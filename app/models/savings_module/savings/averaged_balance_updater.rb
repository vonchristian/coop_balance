module SavingsModule
  module Savings 
    class AveragedBalanceUpdater 
      attr_reader :saving, :date 

      def initialize(saving:, date:)
        @saving = saving 
        @date   = date 
      end 
      
      def update_averaged_balance 
        saving.update(averaged_balance: saving.daily_averaged_balance(date: date))
      end 
    end 
  end 
end 