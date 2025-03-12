module LoansModule
  module Loans
    class LoanAging < ApplicationRecord
      belongs_to :loan,               class_name: "LoansModule::Loan"
      belongs_to :loan_aging_group,   class_name: "LoansModule::LoanAgingGroup"
      belongs_to :receivable_account, class_name: "AccountingModule::Account"

      validates :date, presence: true
      validates :loan_aging_group_id, uniqueness: { scope: :loan_id }
      validates :receivable_account_id, uniqueness: { scope: :loan_id }

      def self.current
        order(date: :desc).first
      end
    end
  end
end
