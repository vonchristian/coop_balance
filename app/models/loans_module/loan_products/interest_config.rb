module LoansModule
  module LoanProducts
    class InterestConfig < ApplicationRecord
      enum amortization_type: [:annually, :straight_balance]
      enum calculation_type: [:add_on, :prededucted]
      enum rate_type: [:monthly_rate, :annual_rate]
      enum prededuction_type: [:percentage, :amount, :number_of_payment]
      belongs_to :loan_product,                     class_name: "LoansModule::LoanProduct"
      belongs_to :interest_revenue_account,         class_name: "AccountingModule::Account"
      belongs_to :unearned_interest_income_account, class_name: "AccountingModule::Account"
      belongs_to :cooperative
      validates :rate, :interest_revenue_account_id, :unearned_interest_income_account_id, presence: true
      validates :rate, numericality: true

      def self.current
        all.order(created_at: :desc).first
      end
      def self.interest_revenue_accounts
        accounts = pluck(:interest_revenue_account_id)
        AccountingModule::Account.where(id: accounts)
      end

      def total_interest(loan_application)
        total = []
        total << loan_application.first_year_interest
        number = loan_application.term
        while number > 12 do
          number -= 12
          total << interest_computation(loan_application.principal_balance(number_of_months: number), number)
        end
        total.sum
      end

      def monthly_rate
        if monthly_rate?
          rate
        elsif annual_rate?
          rate / 12.0
        end
      end

      def interest_computation(balance, term)
        if monthly_rate?
          ((balance * monthly_rate) * term).to_f
        else
          ((balance * rate)).to_f
        end
      end

      def prededucted_interest(amount, term)
        if prededucted?
          compute_prededucted_interest(amount, term)
        else
          0
        end
      end


      def compute_prededucted_interest(amount, term)
        if percentage? && prededucted_rate.present?
          percentage_prededucted_interest(amount, term)
        else
          0
        end
      end


      def create_charges_for(loan_application)
        loan_application.voucher_amounts.create(
        cooperative: loan_application.cooperative,
        description: "Interest on Loan",
        amount: prededucted_interest(loan_application.loan_amount.amount, loan_application.term),
        account: interest_revenue_account,
        amount_type: 'credit' )
      end


      private
      def percentage_prededucted_interest(amount, term)
        interest_computation(amount, term) * prededucted_rate
      end
    end
  end
end
