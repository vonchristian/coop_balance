module LoansModule
  module Loans
    class LoanPenalty < ApplicationRecord
      belongs_to :loan
    end
  end
end
