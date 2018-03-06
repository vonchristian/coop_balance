module LoansModule
  module LoanProducts
    class InterestConfig < ApplicationRecord
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
      belongs_to :interest_revenue_account, class_name: "AccountingModule::Account"
      belongs_to :unearned_interest_income_account, class_name: "AccountingModule::Account"
      belongs_to :interest_receivable_account, class_name: "AccountingModule::Account"
      belongs_to :interest_rebate_account, class_name: "AccountingModule::Account"

      validates :rate, :interest_revenue_account_id, :unearned_interest_income_account_id, presence: true
      validates :rate, numericality: true
      def self.current
        all.order(created_at: :desc).first
      end
      def create_charges_for(loan)
       interest_on_loan_charge = Charge.amount_type.create!(
        name: "Interest on Loan",
        amount: rate * loan.loan_amount,
        account: unearned_interest_income_account)
        loan.loan_charges.find_or_create_by(chargeable: interest_on_loan_charge, commercial_document: loan )
      end
    end
  end
end
