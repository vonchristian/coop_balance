module SavingsModule
  module SavingProducts
    class SavingProductInterestConfig < ApplicationRecord
      # default daily averaged balance

      enum interest_posting: { annually: 0 }
      belongs_to :saving_product,             class_name: 'SavingsModule::SavingProduct'

      validates :annual_rate, presence: true, numericality: true
      validates :minimum_balance, presence: true, numericality: true

      def balance_averager
        "SavingsModule::BalanceAveragers::#{interest_posting.titleize.delete(' ')}".constantize
      end

      def date_setter
        "SavingsModule::DateSetters::#{interest_posting.titleize.delete(' ')}".constantize
      end

      def interest_rate_setter
        "SavingsModule::InterestRateSetters::#{interest_posting.titleize.delete(' ')}".constantize
      end

      def beginning_date(date:)
        date_setter.new(saving_product_interest_config: self, date: date).beginning_date
      end

      def ending_date(date:)
        date_setter.new(saving_product_interest_config: self, date: date).ending_date
      end

      def applicable_rate
        interest_rate_setter.new(saving_product_interest_config: self).applicable_rate
      end
    end
  end
end
