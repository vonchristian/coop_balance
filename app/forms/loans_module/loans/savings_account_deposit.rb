module LoansModule
  module Loans
    class SavingsAccountDeposit
      include ActiveModel::Model
      attr_accessor :amount, :loan_id, :savings_account_id, :employee_id

      def add_to_loan_charges!
        ActiveRecord::Base.transaction do
          save_loan_charge
        end
      end

      private

      def save_loan_charge
        deposit = Charge.amount_type.create(
          name: "Savings Account Deposit",
          amount: amount,
          account: find_savings_account.liability_account
        )
        find_loan.loan_charges.find_or_create_by(
          charge: deposit,
          commercial_document: find_savings_account,
          amount_type: "credit"
        )
      end

      def find_loan
        LoansModule::Loan.find_by(id: loan_id)
      end

      def find_savings_account
        DepositsModule::Saving.find_by(id: savings_account_id)
      end
    end
  end
end
