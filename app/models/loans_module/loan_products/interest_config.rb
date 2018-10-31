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
        ids = pluck(:interest_revenue_account_id)
        AccountingModule::Account.where(id: ids)
      end

      def monthly_rate
        rate / 12.0
      end

      def interest_balance(loan_application)
        total_interest(loan_application)
        # prededucted_interest_amount_for(loan_application)
      end

      def create_charges_for(loan_application)
        loan_application.voucher_amounts.find_or_create_by(
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
        loan_application.loan_amount * monthly_rate * loan_application.term
      end

      def second_year_interest(loan_application)
        if loan_application.term_is_within_two_years?
          loan_application.principal_balance(
            to_date: loan_application.amortization_schedules.order(date: :desc)[12].date,
            from_date:  loan_application.amortization_schedules.order(date: :desc)[23].date) * rate
        end
      end

      def third_year_interest(loan_application)
        if loan_application.amortization_schedules.count > 23
          loan_application.principal_balance(
            to_date: loan_application.amortization_schedules.order(date: :desc)[23].date,
            from_date:  loan_application.amortization_schedules.order(date: :desc)[35].date) * rate
        end
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
