module LoansModule
  class LoanApplicationProcessing
    include ActiveModel::Model
    attr_accessor :borrower_id,
                  :borrower_type,
                  :term,
                  :purpose,
                  :loan_product_id,
                  :loan_amount,
                  :application_date,
                  :mode_of_payment,
                  :account_number,
                  :preparer_id,
                  :cooperative_id,
                  :office_id
    validates :term,  presence: true, numericality: true
    validates :loan_amount, presence: true, numericality: true
    validates :loan_product_id, :mode_of_payment, :term, :application_date, :purpose, presence: true
    def find_loan_application
      LoansModule::LoanApplication.find_by(account_number: account_number)
    end
    def process!
      ActiveRecord::Base.transaction do
        create_loan_application
      end
    end

    def find_loan
      LoansModule::LoanApplication.find_by(account_number: account_number)
    end

    private
    def find_borrower
      Borrower.find(borrower_id)
    end
    def create_loan_application
      loan_application = LoansModule::LoanApplication.create!(
        cooperative: find_preparer.cooperative,
        office: find_preparer.office,
        organization: find_borrower.current_organization,
        purpose: purpose,
        borrower: find_borrower,
        loan_product_id: loan_product_id,
        loan_amount: loan_amount,
        application_date: application_date,
        mode_of_payment: mode_of_payment,
        preparer_id: preparer_id,
        account_number: account_number,
        term: term)
        create_charges(loan_application)

      create_amortization_schedule(loan_application)
    end
    def find_borrower
      Borrower.find(borrower_id)
    end
    def create_charges(loan_application)
      find_loan_product.create_charges_for(loan_application)
    end
    def create_documentary_stamp_tax(loan)
      tax = Charge.amount_type.create!(name: 'Documentary Stamp Tax', amount: DocumentaryStampTax.set(loan), account: AccountingModule::Account.find_by(name: "Documentary Stamp Taxes"))
      loan.loan_charges.create!(charge: tax, commercial_document: loan)
    end
    def create_amortization_schedule(loan_application)
      if loan_application.amortization_schedules.present?
        loan_application.amortization_schedules.destroy_all
      end
      LoansModule::AmortizationSchedule.create_amort_schedule_for(loan_application)
    end
    def find_preparer
      User.find(preparer_id)
    end
    def find_loan_product
      LoansModule::LoanProduct.find(loan_product_id)
    end
  end
end
