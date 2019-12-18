module LoansModule
  module LoanProducts
    class InterestConfig < ApplicationRecord
      extend Totalable
      enum calculation_type: [:add_on, :prededucted, :accrued]

      belongs_to :loan_product,                     class_name: "LoansModule::LoanProduct"
      belongs_to :interest_revenue_account,         class_name: "AccountingModule::Account"
      belongs_to :unearned_interest_income_account, class_name: "AccountingModule::Account"
      belongs_to :past_due_interest_income_account, class_name: "AccountingModule::Account"
      belongs_to :accrued_income_account,           class_name: "AccountingModule::Account"
      belongs_to :cooperative

      validates :rate, :interest_revenue_account_id, :unearned_interest_income_account_id, presence: true
      validates :rate, numericality: true

      def self.current
        order(created_at: :desc).first
      end

      def self.accounts
        interest_revenue_accounts
      end

      def self.interest_revenue_accounts
        accounts = pluck(:interest_revenue_account_id).uniq
        AccountingModule::Account.where(id: accounts)
      end

      def compute_interest(args={})
        (args[:amount] * monthly_interest_rate) * applicable_term(args[:number_of_days]).to_f
      end

      def monthly_interest_rate
        rate / 12.0
      end

      def applicable_term(number_of_days)
        if number_of_days >= 365
          applicable_term = 12
        elsif number_of_days < 30
          applicable_term = 1
        else
          applicable_term = number_of_days / 30.0
        end
      end

    end
  end
end
