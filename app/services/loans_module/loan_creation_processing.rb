module LoansModule
  class LoanCreationProcessing
    include ActiveModel::Model
    attr_reader :loan_application, :cooperative, :employee

    def initialize(args)
      @loan_application = args[:loan_application]
      @employee         = args[:employee]
      @cooperative      = @loan_application.cooperative
    end

    def find_loan
      LoansModule::Loan.find_by(account_number: loan_application.account_number)
    end

    def process!
      ActiveRecord::Base.transaction do
        create_loan
      end
    end

    private
    def create_loan
      loan = LoansModule::Loan.current_loan.new(
        borrower_name:            loan_application.borrower.name,
        loan_application:         loan_application,
        mode_of_payment:          loan_application.mode_of_payment,
        cooperative:              loan_application.cooperative,
        organization:             loan_application.organization,
        office:                   loan_application.office,
        loan_amount:              loan_application.loan_amount.amount,
        application_date:         loan_application.application_date,
        borrower:                 loan_application.borrower,
        loan_product:             loan_application.loan_product,
        preparer:                 employee,
        account_number:           loan_application.account_number,
        purpose:                  loan_application.purpose,
        disbursement_voucher:     loan_application.voucher,
        last_transaction_date:    loan_application.application_date,
        tracking_number:          loan_application.voucher.reference_number,
        receivable_account:       loan_application.receivable_account,
        interest_revenue_account: loan_application.interest_revenue_account
        )
      create_accounts(loan)
      create_term(loan)
      loan.save!

      create_amortization_schedules(loan)
      create_loan_interests(loan)
      create_loan_group(loan)
      approve_loan_application
    end

    def create_accounts(loan)
      ::AccountCreators::Loan.new(loan: loan).create_accounts!
    end

    def create_loan_group(loan)
      ::LoansModule::Loans::LoanAgingGroupUpdate.new(loan: loan, date: loan.application_date).update_loan_aging_group!
    end

    def create_amortization_schedules(loan)
      loan.amortization_schedules << loan_application.amortization_schedules
    end

    def create_term(loan) #move to entry processing
      term = Term.create!(
      term:             loan_application.term,
      effectivity_date: loan_application.application_date,
      maturity_date:    loan_application.application_date + loan_application.term.to_i.months)
      loan.update(term: term)
    end

    def create_loan_interests(loan)
      if loan.loan_product.current_interest_config.prededucted?
        loan.loan_interests.create!(
          date: loan_application.application_date,
          amount: loan_application.total_interest,
          description: "Computed loan interests on #{loan_application.application_date.strftime("%B %e, %Y")}",
          employee: employee)
      end
    end

    def approve_loan_application
      loan_application.update(approved: true)
    end
  end
end
