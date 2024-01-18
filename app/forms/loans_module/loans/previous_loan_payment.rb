module LoansModule
  module Loans
    class PreviousLoanPayment
      include ActiveModel::Model
      attr_accessor :principal_amount,
                    :interest_amount,
                    :penalty_amount,
                    :discount_amount,
                    :loan_id,
                    :previous_loan_id,
                    :description,
                    :reference_number,
                    :date

      validates :principal_amount, :interest_amount, presence: true, numericality: true
      validates :penalty_amount, numericality: true

      def save
        ActiveRecord::Base.transaction do
          create_loan_charges
        end
      end

      private

      def find_loan
        LoansModule::Loan.find_by(id: loan_id)
      end

      def find_previous_loan
        LoansModule::Loan.find_by(id: previous_loan_id)
      end

      def create_loan_charges
        principal = Charge.amount_type.create(amount: principal_amount, account_id: find_previous_loan.loan_product.current_account_id, name: 'Previous Loan Principal')
        interest = Charge.amount_type.create(amount: interest_amount, account: find_previous_loan.loan_product.unearned_interest_income_account, name: 'Previous Loan Interest')
        penalty = Charge.amount_type.create!(amount: penalty_amount, account: find_previous_loan.loan_product.penalty_revenue_account, name: 'Previous Loan Penalty')

        find_loan.loan_charges.create(charge: principal, commercial_document: find_previous_loan, amount_type: 'credit')
        find_loan.loan_charges.create(charge: interest, commercial_document: find_previous_loan, amount_type: 'credit')
        find_loan.loan_charges.create!(charge: penalty, commercial_document: find_previous_loan, amount_type: 'credit')
      end
    end
  end
end
