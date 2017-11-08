module LoansModule
  class LoanProductInterest < ApplicationRecord
    belongs_to :loan_product
    belongs_to :account, class_name: "AccountingModule::Account"
    validates :account_id, presence: true
  end
end
