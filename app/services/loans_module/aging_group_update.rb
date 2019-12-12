module LoansModule
  class AgingGroupUpdate
    attr_reader :loans, :date

    def initialize(loans:, date:)
      @date  = date
      @loans = loans
    end

    def update_aging_group!
      loans.each do |loan|
        LoansModule::Loans::LoanAgingGroupUpdate.new(loan: loan, date: date).update_loan_aging_group!
      end
    end
  end
end
