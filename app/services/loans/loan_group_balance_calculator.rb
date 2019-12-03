module Loans
  class LoanGroupBalanceCalculator
    attr_reader :loan, :loan_aging_group

    def initialize(loan:, loan_aging_group:)
      @loan       = loan
      @loan_group = loan_aging_group
    end

    def balance
      if loan.loan_aging_group == loan_aging_group
        loan.balance
      else
        0
      end
    end
  end
end
