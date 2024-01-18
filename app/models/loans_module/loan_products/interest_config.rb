module LoansModule
  module LoanProducts
    class InterestConfig < ApplicationRecord
      extend Totalable
      enum calculation_type: { add_on: 0, prededucted: 1 }

      belongs_to :loan_product,  class_name: 'LoansModule::LoanProduct'

      validates :rate, presence: true, numericality: true

      def self.current
        order(created_at: :desc).last
      end

      def compute_interest(args = {})
        (args[:amount] * monthly_interest_rate) * applicable_term(args[:number_of_days]).to_f
      end

      def monthly_interest_rate
        rate / 12.0
      end

      def applicable_term(number_of_days)
        if number_of_days >= 365
          12
        elsif number_of_days < 30
          1
        else
          number_of_days / 30.0
        end
      end
    end
  end
end
