module LoansModule
  class LoanApplicationProcessing
    include ActiveModel::Model
    attr_accessor :borrower_id,
                  :borrower_type,
                  :term,
                  :loan_product_id,
                  :loan_amount,
                  :application_date,
                  :mode_of_payment,
                  :account_number,
                  :preparer_id,
                  :cooperative_id
    validates :term, :loan_amount, presence: true, numericality: true
    validates :loan_product_id, :mode_of_payment, :term, :loan_amount, :application_date, presence: true
    def save
      ActiveRecord::Base.transaction do
        create_loan
      end
    end

    def find_loan
      LoansModule::LoanApplication.find_by(account_number: account_number)
    end

    private
    def find_borrower
      Borrower.find(borrower_id)
    end
    def create_loan
      loan_application = LoansModule::LoanApplication.create!(
        cooperative_id: cooperative_id,
        borrower_id: borrower_id,
        borrower_type: borrower_type,
        loan_product_id: loan_product_id,
        loan_amount: loan_amount,
        application_date: application_date,
        mode_of_payment: mode_of_payment,
        preparer_id: preparer_id,
        account_number: account_number,
        term: term)
      # loan = LoansModule::Loan.create!(
      #   cooperative_id: cooperative_id,
      #   borrower_id: borrower_id,
      #   borrower_type: borrower_type,
      #   loan_product_id: loan_product_id,
      #   loan_amount: loan_amount,
      #   application_date: application_date,
      #   mode_of_payment: mode_of_payment,
      #   preparer_id: preparer_id,
      #   account_number: account_number,
      #   terms_attributes: [
      #     term: term])
      create_amortization_schedule(loan_application)
      create_charges(loan_application)
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
