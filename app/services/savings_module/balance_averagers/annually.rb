module SavingsModule
  module BalanceAveragers
    class Annually
      attr_reader :saving, :beginning_date, :ending_date

      def initialize(saving:, date:)
        @saving                         = saving
        @date                           = date
        @saving_product                 = @saving.saving_product
        @saving_product_interest_config = @saving_product.saving_product_interest_config
        @beginning_date                 = @saving_product_interest_config.beginning_date(date: @date)
        @ending_date                    = @saving_product_interest_config.ending_date(date: @date)
      end

      def daily_averaged_balance
        daily_balances / total_number_of_days
      end

      def total_number_of_days
        date_range.size
      end

      def date_range
        (beginning_date..ending_date).to_a
      end

      def daily_balances
        balances = BigDecimal("0")
        date_range.each do |date|
          balances += saving.balance(to_date: date.end_of_day)
        end
        balances
      end
    end
  end
end
