module LoansModule
  module LoanProducts
    class InterestConfig < ApplicationRecord
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

      def interest_balance(loan_application)
       loan_application.voucher_amounts.for_account(account: interest_revenue_account).sum(&:amount).to_f -
       total_interest(loan_application).to_f
      end

      def create_charges_for(loan_application)
        loan_application.voucher_amounts.create(
        cooperative: loan_application.cooperative,
        description: "Interest on Loan",
        amount: prededucted_interest_amount_for(loan_application),
        account: interest_revenue_account,
        amount_type: 'credit' )
      end


      def total_interest(loan_application)
        if loan_application.term_is_within_one_year?
          first_year_interest(loan_application)
        elsif loan_application.term_is_within_two_years?
          first_year_interest(loan_application) +
          second_year_interest(loan_application)
        elsif loan_application.term_is_within_three_years?
          first_year_interest(loan_application) +
          second_year_interest(loan_application) +
          third_year_interest(loan_application)
        end
      end
      def first_year_interest(loan_application)
        term = loan_application.term
        loan_application.amortization_schedules.take(term).sum(&:principal) * rate
      end

      def second_year_interest(loan_application)
        term = loan_application.term - 12
        loan_application.amortization_schedules.take(term).sum(&:principal) * rate
      end

      def third_year_interest(loan_application)
        term = loan_application.term - 24
        loan_application.amortization_schedules.take(term).sum(&:principal) * rate
      end

      def prededucted_interest_amount_for(loan_application)
        if prededucted?
          compute_prededucted_interest(loan_application)
        else
          0
        end
      end

      def compute_prededucted_interest(loan_application)
        if percentage?
        #for kcmdc
          (loan_application.loan_amount.amount * rate) * prededucted_rate
        elsif number_of_payment?
          #for kccmc
          loan_application.amortization_schedules.order(date: :desc).take(number_of_payment).sum(:interest)
        end
      end
    end
  end
end
