module LoansModule
  class LoanProtectionPlanProvider < ApplicationRecord
    belongs_to :cooperative
    belongs_to :accounts_payable, class_name: "AccountingModule::Account"
    has_many   :loan_products,    class_name: "LoansModule::LoanProduct"
    has_many   :loans,            through: :loan_products, class_name: "LoansModule::Loan"

    validates :business_name, presence: true, uniqueness: { scope: :cooperative_id }
    validates :rate, presence: true, numericality: true
    delegate :name, to: :accounts_payable, prefix: true

    def amount_for(loan_application)
      rate * loan_application.number_of_thousands * loan_application.term
    end
  end
end
