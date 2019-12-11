module LoansModule
  module Loans
    class LoanTerm < ApplicationRecord
      belongs_to :loan, class_name: 'LoansModule::Loan'
      belongs_to :term

      validates :term_id, uniqueness: { scope: :loan_id }
    end
  end
end
