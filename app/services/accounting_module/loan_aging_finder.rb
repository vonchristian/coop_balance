module AccountingModule
  class LoanAgingFinder
    attr_reader :loans

    def initialize(loans:)
      @loans = loans
    end

    def aging_loans
      @aging_loans ||= loans.reject { |a| a.receivable_account_id == a.loan_aging.receivable_account_id }
    end
  end
end
