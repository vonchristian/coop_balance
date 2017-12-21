module LoansModule
  class PreviousLoanPaymentForm
    include ActiveModel::Model
    attr_accessor :principal_amount,
                  :interest_amount,
                  :penalty_amount,
                  :discount_amount,
                  :loan_id,
                  :previous_loan_id,
                  :description,
                  :reference_number,
                  :date
    def save
      ActiveRecord::Base.transaction do
        create_loan_charges
      end
    end

    private
    def find_loan
      LoansModule::Loan.find_by(id: loan_id)
    end

    def find_previous_loan
      LoansModule::Loan.find_by(id: previous_loan_id)
    end

    def create_loan_charges
      principal = Charge.create(amount: principal_amount, account_id: find_previous_loan.loan_product.account_id, name: "Previous Loan Principal")
      find_loan.loan_charges.create(chargeable: principal, commercial_document: find_previous_loan)
    end
  end
end
