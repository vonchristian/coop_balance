module LoansModule
  class InterestConfig < ApplicationRecord
    belongs_to :loan_product
    belongs_to :earned_interest_income_account, class_name: "AccountingModule::Accountc"
    belongs_to :interest_receivable_account, class_name: "AccountingModule::Accountc"
    belongs_to :unearned_interest_income_account, class_name: "AccountingModule::Account"

    def create_interest_on_loan_charge_for(loan)
      interest_on_loan_charge = Charge.create(name: "Interest on Loan", amount: (self.rate / 100) * loan.loan_amount, account_id: self.interest_receivable_account_id)
      loan.loan_charges.find_or_create_by(chargeable: interest_on_loan_charge, commercial_document: loan )
    end
  end
end
