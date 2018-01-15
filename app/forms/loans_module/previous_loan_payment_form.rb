module LoansModule
  class PreviousLoanPaymentForm
    include ActiveModel::Model
    include ActiveModel::Callbacks
    attr_accessor :principal_amount,
                  :interest_amount,
                  :penalty_amount,
                  :discount_amount,
                  :loan_id,
                  :previous_loan_id,
                  :description,
                  :reference_number,
                  :date
    validates :principal_amount, :interest_amount, presence: true, numericality: true
    validates :penalty_amount, numericality: true

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
      interest = Charge.create(amount: interest_amount, account_id: find_previous_loan.loan_product.interest_account_id, name: "Previous Loan Interest")
      penalty = Charge.create!(amount: penalty_amount, account_id: find_previous_loan.loan_product.penalty_account_id, name: "Previous Loan Penalty")

      find_loan.loan_charges.create(chargeable: principal, commercial_document: find_previous_loan)
      find_loan.loan_charges.create(chargeable: interest, commercial_document: find_previous_loan)
      find_loan.loan_charges.create!(chargeable: penalty, commercial_document: find_previous_loan)


    end
  end
end
