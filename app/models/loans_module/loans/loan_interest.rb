module LoansModule
  module Loans
    class LoanInterest < ApplicationRecord
      belongs_to :loan
    end
  end
end
