module LoansModule
  module LoanProducts
    class InterestConfig < ApplicationRecord
      enum amortization_type: [:annually, :straight_balance]
      enum calculation_type: [:add_on, :prededucted]
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

      def monthly_rate
        rate / 12.0
      end


      def create_charges_for(loan_application)
        loan_application.voucher_amounts.create(
        cooperative: loan_application.cooperative,
        description: "Interest on Loan",
        amount: loan_application.prededucted_interest,
        account: interest_revenue_account,
        amount_type: 'credit' )
      end
    end
  end
end
