module LoansModule
  class InterestConfig < ApplicationRecord
    belongs_to :loan_product
    belongs_to :interest_revenue_account, class_name: "AccountingModule::Account"
    belongs_to :unearned_interest_income_account, class_name: "AccountingModule::Account"

    validates :rate, :interest_revenue_account_id, :unearned_interest_income_account_id, presence: true
    validates :rate, numericality: true
    def create_charges_for(loan)
     interest_on_loan_charge = Charge.amount_type.create!(name: "Interest on Loan", amount: (self.rate) * loan.loan_amount, account_id: self.interest_revenue_account_id)
      loan.loan_charges.find_or_create_by(chargeable: interest_on_loan_charge, commercial_document: loan )
    end


    def prededucted?
      if post_to_unearned_interest_income
        #count_number_of_months_prededucted
      else
      post_to_revenue_account
    end
  end
  end
end
