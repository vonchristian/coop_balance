module LoansModule
  class LoanCreationProcessing
    include ActiveModel::Model
    attr_reader :loan_application, :employee, :loan_product, :account_number

    def initialize(args)
      @loan_application = args[:loan_application]
      @employee         = @loan_application.preparer
      @loan_product     = @loan_application.loan_product
      @account_number   = account_number
    end
    def find_loan
      LoansModule::Loan.find_by(account_number: account_number)
    end

    def process!
      ActiveRecord::Base.transaction do
        create_loan
      end
    end

    private
    def create_loan
      loan = LoansModule::Loan.create!(
        loan_application: loan_application,
        mode_of_payment:  loan_application.mode_of_payment,
        cooperative:      loan_application.cooperative,
        organization:     loan_application.organization,
        office:           loan_application.office,
        loan_amount:      loan_application.loan_amount,
        application_date: loan_application.application_date,
        borrower:         loan_application.borrower,
        loan_product:     loan_product,
        preparer:         employee,
        account_number:   account_number,
        purpose:          loan_application.purpose
        )
      loan.amortization_schedules << loan_application.amortization_schedules
      create_voucher_amounts(loan)
      loan.update_attributes(disbursement_voucher: loan_application.voucher)
      loan.terms.create(
        term: loan_application.term)
      create_loan_interests(loan)
    end

    def create_voucher_amounts(loan)
      loan.voucher_amounts << loan_application.voucher_amounts
    end

    def create_loan_interests(loan)
      loan.loan_interests.create!(
        amount: loan_application.interest_balance,
        description: "Interest balance",
        computed_by: employee)
    end
  end
end
